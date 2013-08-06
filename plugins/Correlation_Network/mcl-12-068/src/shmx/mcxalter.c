/*   (C) Copyright 2006, 2007, 2008, 2009, 2010, 2011 Stijn van Dongen
 *
 * This file is part of MCL.  You can redistribute and/or modify MCL under the
 * terms of the GNU General Public License; either version 3 of the License or
 * (at your option) any later version.  You should have received a copy of the
 * GPL along with MCL, in the file COPYING.
 *
 * NOTE
 * this file implements both /diameter/ and /ctty/ (centrality)
 * functionality for mcx.
*/

/* TODO
 * -  Handle components.
 * -  Clean up diameter/ctty organization.
*/


#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <time.h>

#include "mcx.h"

#include "util/types.h"
#include "util/ding.h"
#include "util/ting.h"
#include "util/io.h"
#include "util/err.h"
#include "util/opt.h"
#include "util/compile.h"
#include "util/rand.h"

#include "impala/matrix.h"
#include "impala/tab.h"
#include "impala/io.h"
#include "impala/stream.h"
#include "impala/app.h"

#include "clew/clm.h"
#include "mcl/transform.h"

static const char* me = "mcx alter";

enum
{  MY_OPT_ABC    =   MCX_DISP_UNUSED
,  MY_OPT_IMX
,  MY_OPT_TAB
,  MY_OPT_O
,  MY_OPT_TRANSFORM
,  MY_OPT_CANONICAL
}  ;


mcxOptAnchor alterOptions[] =
{  {  "-imx"
   ,  MCX_OPT_HASARG
   ,  MY_OPT_IMX
   ,  "<fname>"
   ,  "specify input matrix/graph"
   }
,  {  "-abc"
   ,  MCX_OPT_HASARG
   ,  MY_OPT_ABC
   ,  "<fname>"
   ,  "specify input using label pairs"
   }
,  {  "-tab"
   ,  MCX_OPT_HASARG
   ,  MY_OPT_TAB
   ,  "<fname>"
   ,  "specify tab file to be used with matrix input"
   }
,  {  "-o"
   ,  MCX_OPT_HASARG
   ,  MY_OPT_O
   ,  "<fname>"
   ,  "write to file fname"
   }
,  {  "-tf"
   ,  MCX_OPT_HASARG
   ,  MY_OPT_TRANSFORM
   ,  "<func(arg)[, func(arg)]*>"
   ,  "apply unary transformations to matrix values"
   }
,  {  "-canonical"
   ,  MCX_OPT_HASARG | MCX_OPT_HIDDEN
   ,  MY_OPT_CANONICAL
   ,  "<num>"
   ,  "add canonical vector in the middle with <num> nodes"
   }
,  {  NULL, 0, 0, NULL, NULL }
}  ;


static  mcxIO* xfmx_g      =   (void*) -1;
static  mcxIO* xfabc_g     =   (void*) -1;
static  mcxIO* xftab_g     =   (void*) -1;
static  mcxIO* xfout_g     =   (void*) -1;
static  mclTab* tab_g      =   (void*) -1;
static  dim canonical_g    =   -1;
static  mclgTF* transform  =   (void*) -1;
static  mcxTing* transform_spec = (void*) -1;


static mcxstatus alterInit
(  void
)
   {  xfmx_g         =  mcxIOnew("-", "r")
   ;  xfabc_g        =  NULL
   ;  xftab_g        =  NULL
   ;  xfout_g        =  mcxIOnew("-", "w")
   ;  transform      =  NULL
   ;  transform_spec =  NULL
   ;  tab_g          =  NULL
   ;  canonical_g    =  0
   ;  return STATUS_OK
;  }


static mcxstatus alterArgHandle
(  int optid
,  const char* val
)
   {  switch(optid)
      {  case MY_OPT_IMX
      :  mcxIOnewName(xfmx_g, val)
      ;  break
      ;

         case MY_OPT_ABC
      :  xfabc_g = mcxIOnew(val, "r")
      ;  break
      ;

         case MY_OPT_O
      :  mcxIOnewName(xfout_g, val)
      ;  break
      ;

         case MY_OPT_CANONICAL
      :  canonical_g = atoi(val)
      ;  break
      ;  

         case MY_OPT_TAB
      :  xftab_g = mcxIOnew(val, "r")
      ;  break
      ;

         case MY_OPT_TRANSFORM
      :  transform_spec = mcxTingNew(val)
      ;  break
      ;

         default
      :  mcxExit(1)
      ;
   ;  }
      return STATUS_OK
;  }


static mcxstatus alterMain
(  int          argc_unused      cpl__unused
,  const char*  argv_unused[]    cpl__unused
)
   {  mclx* mx                =  NULL

   ;  mclxIOstreamer streamer = { 0 }

   ;  srandom(mcxSeed(11235813))

   ;  mcxLogLevel =
      MCX_LOG_AGGR | MCX_LOG_MODULE | MCX_LOG_IO | MCX_LOG_GAUGE | MCX_LOG_WARN
   ;  mclx_app_init(stderr)

   ;  if (xfabc_g)
      {  if (xftab_g)
            tab_g = mclTabRead(xftab_g, NULL, EXIT_ON_FAIL)
         ,  streamer.tab_sym_in = tab_g
      ;  mx
      =  mclxIOstreamIn
         (  xfabc_g
         ,     MCLXIO_STREAM_ABC
            |  MCLXIO_STREAM_MIRROR
            |  MCLXIO_STREAM_SYMMETRIC
            |  (tab_g ? MCLXIO_STREAM_GTAB_RESTRICT : 0)
         ,  NULL
         ,  mclpMergeMax
         ,  &streamer
         ,  EXIT_ON_FAIL
         )
      ;  tab_g = streamer.tab_sym_out
   ;  }
      else
      {  mx = mclxRead(xfmx_g, EXIT_ON_FAIL)
      ;  if (xftab_g)
         tab_g = mclTabRead(xftab_g, mx->dom_cols, EXIT_ON_FAIL)
   ;  }

      mcxIOopen(xfout_g, EXIT_ON_FAIL)

   ;  if (transform_spec)
      { if (!(transform = mclgTFparse(NULL, transform_spec)))
         mcxDie(1, me, "input -tf spec does not parse")
      ;  mclgTFexec(mx, transform)
   ;  }

      if (canonical_g)
      {  dim d, e
      ;  for (d=1; d<=canonical_g; d++)
            e = d * (N_COLS(mx) / canonical_g)
         ,  mclvCanonical(mx->cols+e-1, e, 1.0)
   ;  }

      if (tab_g)
      {  mclxIOdumper dumper
      ;  mclxIOdumpSet(&dumper, MCLX_DUMP_PAIRS, NULL, NULL, NULL)
;fprintf(stderr, "HI\n")
      ;  if
         (  mclxIOdump
            (  mx
            ,  xfout_g
            ,  &dumper
            ,  tab_g
            ,  tab_g
            ,  MCLXIO_VALUE_GETENV
            ,  RETURN_ON_FAIL
          ) )
         mcxDie(1, me, "something suboptimal")
   ;  }
      else
      {  if (mclxWrite(mx, xfout_g, MCLXIO_VALUE_GETENV, RETURN_ON_FAIL))
         mcxDie(1, me, "something less than perfect. AAAAAARGH!")
   ;  }

      return 0
;  }


mcxDispHook* mcxDispHookAlter
(  void
)
   {  static mcxDispHook alterEntry
   =  {  "alter"
      ,  "alter [options]"
      ,  alterOptions
      ,  sizeof(alterOptions)/sizeof(mcxOptAnchor) - 1

      ,  alterArgHandle
      ,  alterInit
      ,  alterMain

      ,  0
      ,  0
      ,  MCX_DISP_DEFAULT
      }
   ;  return &alterEntry
;  }


