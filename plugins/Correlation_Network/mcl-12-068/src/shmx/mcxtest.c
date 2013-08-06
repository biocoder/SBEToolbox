/*   (C) Copyright 2006, 2007, 2008, 2009, 2010, 2011 Stijn van Dongen
 *
 * This file is part of MCL.  You can redistribute and/or modify MCL under the
 * terms of the GNU General Public License; either version 3 of the License or
 * (at your option) any later version.  You should have received a copy of the
 * GPL along with MCL, in the file COPYING.
*/


#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <math.h>
#include <stdlib.h>
#include <stdio.h>
#include <limits.h>
#include <string.h>
#include <ctype.h>
#include <signal.h>
#include <time.h>

#include "impala/io.h"
#include "impala/matrix.h"
#include "impala/tab.h"
#include "impala/stream.h"
#include "impala/ivp.h"
#include "impala/compose.h"
#include "impala/vector.h"
#include "impala/app.h"
#include "impala/iface.h"
#include "impala/pval.h"

#include "util/types.h"
#include "util/ding.h"
#include "util/ting.h"
#include "util/io.h"
#include "util/err.h"
#include "util/equate.h"
#include "util/minmax.h"
#include "util/rand.h"
#include "util/opt.h"

#include "mcl/proc.h"
#include "mcl/procinit.h"
#include "mcl/alg.h"

#include "clew/clm.h"
#include "clew/cat.h"

const char* usagelines[];

const char* me = "mcxtest";

void usage
(  const char**
)  ;

mclv* reduce_v
(  const mclv* u
)
   {  mclv* v = mclvClone(u)
   ;  dim n = v->n_ivps
   ;  double s = mclvSum(v)
   ;  double sq = mclvPowSum(v, 2.0)
   ;  if (s)
      mclvSelectGqBar(v, 0.25 * sq / s)
;fprintf(stderr, "from %d to %d entries\n", (int) n, (int) v->n_ivps)
   ;  return v
;  }

double mydiv
(  pval a
,  pval b
)
   {  return b ? a / b : 0.0
;  }


double get_score
(  const mclv* c
,  const mclv* d
,  const mclv* c_start
,  const mclv* d_start
,  const mclv* c_end
,  const mclv* d_end
)
   {  mclv* vecc   = mclvClone(c)
   ;  mclv* vecd   = mclvClone(d)
   ;  mclv* meet_c = mcldMeet(vecc, vecd, NULL)
   ;  mclv* meet_d = mcldMeet(vecd, meet_c, NULL)

   ;  mclv* cwid   = mclvBinary(c_end, c_start, NULL, fltSubtract)
   ;  mclv* dwid   = mclvBinary(d_end, d_start, NULL, fltSubtract)

   ;  mclv* rmin   = mclvBinary(c_end, d_end, NULL, fltMin)
   ;  mclv* lmax   = mclvBinary(c_start, d_start, NULL, fltMax)
   ;  mclv* delta  = mclvBinary(rmin, lmax, NULL, fltSubtract)

   ;  mclv* weightc, *weightd
   ;  double ip, cd, csn, meanc, meand, mean, euclid, meet_fraction, score, sum_meet_c, sum_meet_d, reduction_c, reduction_d

   ;  int nmeet = meet_c->n_ivps
   ;  int nldif = vecc->n_ivps - nmeet
   ;  int nrdif = vecd->n_ivps - nmeet

   ;  mclvSelectGqBar(delta, 0.0)

   ;  weightc= mclvBinary(delta, cwid, NULL, mydiv)
   ;  weightd= mclvBinary(delta, dwid, NULL, mydiv)

#if 0
;if (c != d)mclvaDump
(  cwid
,  stdout
,  5
,  "\n"
,  0)
,mclvaDump
(  dwid
,  stdout
,  5
,  "\n"
,  0)
#endif

   ;  sum_meet_c  = 0.01 + mclvSum(meet_c)
   ;  sum_meet_d  = 0.01 + mclvSum(meet_d)

   ;  mclvBinary(meet_c, weightc, meet_c, fltMultiply)
   ;  mclvBinary(meet_d, weightd, meet_d, fltMultiply)

   ;  reduction_c = mclvSum(meet_c) / sum_meet_c
   ;  reduction_d = mclvSum(meet_d) / sum_meet_d

   ;  ip    = mclvIn(meet_c, meet_d)
   ;  cd    = sqrt(mclvPowSum(meet_c, 2.0) * mclvPowSum(meet_d, 2.0))
   ;  csn   = cd ? ip / cd : 0.0
   ;  meanc = meet_c->n_ivps ? mclvSum(meet_c) / meet_c->n_ivps : 0.0
   ;  meand = meet_d->n_ivps ? mclvSum(meet_d) / meet_d->n_ivps : 0.0
   ;  mean  = MCX_MIN(meanc, meand)

   ;  euclid =   0
              ?  1.0
              :  (  mean
                 ?  sqrt(mclvPowSum(meet_c, 2.0) / mclvPowSum(vecc, 2.0))
                 :  0.0
                 )
   ;  meet_fraction = pow((meet_c->n_ivps * 1.0 / vecc->n_ivps), 1.0)

   ;  score  =  mean * csn * euclid  * meet_fraction * 1.0

   ;  mclvFree(&meet_c)
   ;  mclvFree(&meet_d)

   ;  fprintf
      (  stdout
      ,  "%10d%10d%10d%10d%10d%10g%10g%10g%10g%10g%10g%10g\n"
      ,  (int) c->vid
      ,  (int) d->vid
      ,  (int) nldif
      ,  (int) nrdif
      ,  (int) nmeet
      ,  score
      ,  mean
      ,  csn
      ,  euclid
      ,  meet_fraction
      ,  reduction_c
      ,  reduction_d
      )

   ;  return score
;  }



int main
(  int                  argc
,  const char*          argv[]
)  
   {  mclx* mx_score, *mx_start, *mx_end
   ;  mcxIO* xfs, *xfl, *xfr
   ;  dim i, j

   ;  if (argc != 4)
      mcxDie(1, me, "need score start end matrices")

   ;  xfs = mcxIOnew(argv[1], "r")
   ;  xfl = mcxIOnew(argv[2], "r")
   ;  xfr = mcxIOnew(argv[3], "r")

   ;  mx_score = mclxRead(xfs, EXIT_ON_FAIL)
   ;  mx_start = mclxRead(xfl, EXIT_ON_FAIL)
   ;  mx_end   = mclxRead(xfr, EXIT_ON_FAIL)

   ;  fprintf
      (  stdout
      ,  "%10s%10s%10s%10s%10s%10s%10s%10s%10s%10s%10s%10s\n"
      ,  "vid1"
      ,  "vid2"
      ,  "diff1"
      ,  "diff2"
      ,  "meet"
      ,  "score"
      ,  "mean"
      ,  "csn"
      ,  "euclid"
      ,  "frac"
      ,  "re1"
      ,  "re2"
      )

   ;  for (i=0;i< N_COLS(mx_score);i++)
      {  for (j=0;j<N_COLS(mx_score);j++)
         {  double s
         ;  s =
            get_score
            (  mx_score->cols+i
            ,  mx_score->cols+j
            ,  mx_start->cols+i
            ,  mx_start->cols+j
            ,  mx_end->cols+i
            ,  mx_end->cols+j
            )
      ;  }
      }
      return 0
;  }


const char* usagelines[] =
{  NULL
}  ;


