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
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>
#include <math.h>
#include <stdlib.h>
#include <stdio.h>
#include <limits.h>
#include <string.h>
#include <ctype.h>
#include <signal.h>
#include <time.h>

#include "mcx.h"

#include "util/types.h"
#include "util/ding.h"
#include "util/ting.h"
#include "util/io.h"
#include "util/err.h"
#include "util/opt.h"
#include "util/compile.h"
#include "util/minmax.h"

#include "impala/matrix.h"
#include "impala/tab.h"
#include "impala/io.h"
#include "impala/stream.h"
#include "impala/app.h"

#include "clew/clm.h"
#include "gryphon/path.h"

static const char* mediam = "mcx diameter";
static const char* mectty = "mcx ctty";


         /* this aids in finding heuristically likely starting points
          * for long shortest paths, by looking at dead ends
          * in the lattice.
          * experimental, oefully underdocumented.
         */
static dim diameter_rough
(  mclv*       vec
,  mclx*       mx
,  u8*         rough_scratch
,  long*       rough_priority
)
   {  mclv* curr  =  mclvInsertIdx(NULL, vec->vid, 1.0) 
   ;  mclpAR* par =  mclpARensure(NULL, 1024)

   ;  dim d = 0, n_dead_ends = 0, n_dead_ends_res = 0

   ;  memset(rough_scratch, 0, N_COLS(mx))

   ;  rough_scratch[vec->vid] = 1                        /* seen */
   ;  rough_priority[vec->vid] = -1              /* remove from priority list */

   ;  while (1)
      {  mclp* currivp = curr->ivps
      ;  dim t
      ;  mclpARreset(par)
      ;  while (currivp < curr->ivps + curr->n_ivps)
         {  mclv* ls = mx->cols+currivp->idx
         ;  mclp* newivp = ls->ivps
         ;  int hit = 0
         ;  while (newivp < ls->ivps + ls->n_ivps)
            {  u8* tst = rough_scratch+newivp->idx
            ;  if (!*tst || *tst & 2)
               {  if (!*tst)
                  mclpARextend(par, newivp->idx, 1.0)
               ;  *tst = 2
               ;  hit = 1
            ;  }
               newivp++
         ;  }
            if (!hit && rough_priority[currivp->idx] >= 0)
               rough_priority[currivp->idx] += d+1
            ,  n_dead_ends_res++
         ;  else if (!hit)
            n_dead_ends++
/* ,fprintf(stderr, "[%ld->%ld]", (long) currivp->idx, (long) rough_priority[currivp->idx])
*/
;
#if 0
if (currivp->idx == 115 || currivp->idx == 128)
fprintf(stdout, "pivot %d node %d d %d dead %d pri %d\n", (int) vec->vid, (int) currivp->idx, d, (int) (1-hit), (int) rough_priority[currivp->idx])
#endif
         ;  currivp++
      ;  }
         if (!par->n_ivps)
         break
      ;  d++
      ;  mclvFromIvps(curr, par->ivps, par->n_ivps)
      ;  for (t=0;t<curr->n_ivps;t++)
         rough_scratch[curr->ivps[t].idx] = 1
   ;  }

      mclvFree(&curr)
   ;  mclpARfree(&par)
;if(0)fprintf(stdout, "deadends %d / %d\n", (int) n_dead_ends, (int) n_dead_ends_res)
   ;  return d
;  }


typedef struct
{  ofs      node_idx
;  double   n_paths_lft
;  double   acc_wtd_global
;  double   acc_wtd_local  /* accumulator, weighted */
;  dim      acc_chr        /* accumulator, characteristic */
;  mcxLink* nb_lft         /* list of neighbours, NULL terminated */
;  mcxLink* nb_rgt         /* list of neighbours, NULL terminated */
;
}  SSPnode  ;


enum
{  MY_OPT_ABC    =   MCX_DISP_UNUSED
,  MY_OPT_IMX
,  MY_OPT_TAB
,  MY_OPT_OUT
,  MY_OPT_LIST_MAX
,  MY_OPT_LIST_NODES
,  MY_OPT_T
,  MY_OPT_G
,  MY_OPT_littleG
,  MY_OPT_EXTENT
,  MY_OPT_WEIGHTED
,  MY_OPT_INCLUDE_ENDS
,  MY_OPT_MOD
,  MY_OPT_ROUGH
}  ;


mcxOptAnchor diameterOptions[] =
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
   ,  MY_OPT_OUT
   ,  "<fname>"
   ,  "write to file fname"
   }
,  {  "-t"
   ,  MCX_OPT_HASARG
   ,  MY_OPT_T
   ,  "<int>"
   ,  "number of threads to use"
   }
,  {  "-J"
   ,  MCX_OPT_HASARG
   ,  MY_OPT_G
   ,  "<int>"
   ,  "number of compute jobs overall"
   }
,  {  "-j"
   ,  MCX_OPT_HASARG
   ,  MY_OPT_littleG
   ,  "<int>"
   ,  "index of this compute job"
   }
,  {  "--rough"
   ,  MCX_OPT_HIDDEN
   ,  MY_OPT_ROUGH
   ,  NULL
   ,  "use direct computation (testing only)"
   }
,  {  "--summary"
   ,  MCX_OPT_DEFAULT
   ,  MY_OPT_LIST_MAX
   ,  NULL
   ,  "return length of longest shortest path"
   }
,  {  "--list"
   ,  MCX_OPT_DEFAULT
   ,  MY_OPT_LIST_NODES
   ,  NULL
   ,  "list eccentricity for all nodes (default)"
   }
,  {  NULL, 0, 0, NULL, NULL }
}  ;


mcxOptAnchor cttyOptions[] =
{  {  "-imx"
   ,  MCX_OPT_HASARG
   ,  MY_OPT_IMX
   ,  "<fname>"
   ,  "specify input matrix"
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
   ,  MY_OPT_OUT
   ,  "<fname>"
   ,  "write to file fname"
   }
,  {  "-t"
   ,  MCX_OPT_HASARG
   ,  MY_OPT_T
   ,  "<int>"
   ,  "number of threads to use"
   }
,  {  "-J"
   ,  MCX_OPT_HASARG
   ,  MY_OPT_G
   ,  "<int>"
   ,  "number of compute jobs overall"
   }
,  {  "-j"
   ,  MCX_OPT_HASARG
   ,  MY_OPT_littleG
   ,  "<int>"
   ,  "index of this compute job"
   }
,  {  "-extent"
   ,  MCX_OPT_HASARG
   ,  MY_OPT_EXTENT
   ,  "<int>"
   ,  "limit centrality computation to nodes with step-distance <int>"
   }
,  {  "--rough"
   ,  MCX_OPT_HIDDEN
   ,  MY_OPT_ROUGH
   ,  NULL
   ,  "use direct computation (testing only)"
   }
,  {  "--with-ends"
   ,  MCX_OPT_DEFAULT | MCX_OPT_HIDDEN
   ,  MY_OPT_INCLUDE_ENDS
   ,  NULL
   ,  "include scores for lattice sources and sinks"
   }
#if 0             /* nope, not yet implemented. Is there a point even? */
,  {  "--weighted"
   ,  MCX_OPT_DEFAULT
   ,  MY_OPT_WEIGHTED
   ,  NULL
   ,  "compute weighted centrality"
   }
#endif
,  {  "--list"
   ,  MCX_OPT_DEFAULT | MCX_OPT_HIDDEN
   ,  MY_OPT_LIST_NODES
   ,  NULL
   ,  "(default) list mode"
   }
,  {  "--mod"
   ,  MCX_OPT_HIDDEN
   ,  MY_OPT_MOD
   ,  NULL
   ,  "add 1 to each sub-score"
   }
,  {  NULL, 0, 0, NULL, NULL }
}  ;

static  unsigned debug_g   =   -1;

static  mcxIO* xfmx_g      =   (void*) -1;
static  mcxIO* xfabc_g     =   (void*) -1;
static  mcxIO* xftab_g     =   (void*) -1;
static  mclTab* tab_g      =   (void*) -1;
static  dim progress_g     =   -1;
static  mcxbool rough      =   -1;
static  mcxbool list_nodes =   -1;
static  mcxbool mod_up     =   -1;
static  mcxbool weighted_g =   -1;

static const char* out_g   =   (void*) -1;

static mcxbool include_ends_g  =  -1;
static dim n_group_G       =  -1;
static dim i_group         =  -1;
static dim n_thread_l      =  -1;
static dim extent_g        =  -1;         /* ctty depth */

static mcxstatus allInit
(  void
)
   {  xfmx_g         =  mcxIOnew("-", "r")
   ;  xfabc_g        =  NULL
   ;  xftab_g        =  NULL
   ;  tab_g          =  NULL
   ;  progress_g     =  0
   ;  rough          =  FALSE
   ;  list_nodes     =  TRUE
   ;  mod_up         =  FALSE
   ;  n_group_G      =  1
   ;  i_group        =  0
   ;  n_thread_l     =  0
   ;  include_ends_g =  FALSE
   ;  out_g          =  "-"
   ;  debug_g        =  0
   ;  weighted_g     =  FALSE
   ;  extent_g       =  0
   ;  return STATUS_OK
;  }


static mcxstatus cttyArgHandle
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

         case MY_OPT_TAB
      :  xftab_g = mcxIOnew(val, "r")
      ;  break
      ;

         case MY_OPT_OUT
      :  out_g = val
      ;  break
      ;

         case MY_OPT_INCLUDE_ENDS
      :  include_ends_g = TRUE
      ;  break
      ;

         case MY_OPT_LIST_NODES
      :  break
      ;

         case MY_OPT_littleG
      :  i_group =  atoi(val)
      ;  break
      ;

         case MY_OPT_G
      :  n_group_G =  atoi(val)
      ;  break
      ;

         case MY_OPT_EXTENT
      :  extent_g = (unsigned) atoi(val)
      ;  break
      ;

         case MY_OPT_T
      :  n_thread_l = (unsigned) atoi(val)
      ;  break
      ;

         case MY_OPT_WEIGHTED
      :  weighted_g = TRUE
      ;  break
      ;

         case MY_OPT_MOD
      :  mod_up = TRUE
      ;  break
      ;

         default
      :  mcxExit(1)
      ;
   ;  }
      return STATUS_OK
;  }


static mcxstatus diameterArgHandle
(  int optid
,  const char* val
)
   {  switch(optid)
      {  case MY_OPT_IMX
      :  mcxIOnewName(xfmx_g, val)
      ;  break
      ;

         case MY_OPT_LIST_NODES
      :  list_nodes = TRUE
      ;  break
      ;

         case MY_OPT_T
      :  n_thread_l = (unsigned) atoi(val)
      ;  break
      ;

         case MY_OPT_LIST_MAX
      :  list_nodes = FALSE
      ;  break
      ;

         case MY_OPT_ROUGH
      :  rough = TRUE
      ;  break
      ;

         case MY_OPT_TAB
      :  xftab_g = mcxIOnew(val, "r")
      ;  break
      ;

         case MY_OPT_OUT
      :  out_g = val
      ;  break
      ;

         case MY_OPT_littleG
      :  i_group =  atoi(val)
      ;  break
      ;

         case MY_OPT_G
      :  n_group_G =  atoi(val)
      ;  break
      ;

         case MY_OPT_ABC
      :  xfabc_g = mcxIOnew(val, "r")
      ;  break
      ;

         default
      :  mcxExit(1) 
      ;
   ;  }
      return STATUS_OK
;  }


static void rough_it
(  mclx* mx
,  dim* tabulator
,  dim i
,  u8* rough_scratch
,  long* rough_priority
,  dim* pri
)
   {  dim dd = 0, p = i, p1 = 0, p2 = 0, priority = 0, p1p2 = 0, j = 0
      
   ;  for (j=0;j<N_COLS(mx);j++)
      {  if (1)
         {  if (rough_priority[j] >= rough_priority[p1])
               p2 = p1
            ,  p1 = j
         ;  else if (rough_priority[j] >= rough_priority[p2])
            p2 = j
      ;  }
         else
         {  if (!p1 && rough_priority[j] >= 1)
            p1 = j
      ;  }
      }
      p = p1
   ;  priority = rough_priority[p]
   ;  p1p2 = rough_priority[p1] + rough_priority[p2]
   ;  dd = diameter_rough(mx->cols+p, mx, rough_scratch, rough_priority)
;if (0)
fprintf
(  stdout
,  "guard %6d--%-6d %6d %6d NODE %6d ECC %6d PRI\n"
,  (int) p1p2
,  (int) (i * dd)
,  (int) i
,  (int) p
,  (int) dd
,  (int) priority
)
   ;  *pri = priority
   ;  tabulator[p] = dd
;  }


static void ecc_compute
(  dim* tabulator
,  const mclx* mx
,  dim offset
,  dim inc
,  mclv* scratch
)
   {  dim i
   ;  for (i=offset;i<N_COLS(mx);i+=inc)
      {  dim dd = mclgEcc2(mx->cols+i, mx, scratch)
      ;  tabulator[i] = dd
   ;  }
   }



typedef struct
{  dim*     tabulator
;  mclv*    scratch
;
}  diam_data   ;


static void diam_dispatch
(  mclx* mx
,  dim i
,  void* data
,  dim thread_id 
)
   {  diam_data* d = ((diam_data*) data) + thread_id
   ;  dim dd = mclgEcc2(mx->cols+i, mx, d->scratch)
   ;  d->tabulator[i] = dd
;  }


static mcxstatus diameterMain
(  int          argc_unused      cpl__unused
,  const char*  argv_unused[]    cpl__unused
)
   {  mclx* mx                =  NULL
   ;  mcxbool canonical       =  FALSE

   ;  dim* tabulator          =  NULL

   ;  mclv* ecc_scratch       =  NULL
   ;  mcxIO* xfout            =  mcxIOnew(out_g, "w")

   ;  double sum = 0.0

   ;  dim thediameter = 0
   ;  dim i, n_thread_g

   ;  progress_g  =  mcx_progress_g
   ;  debug_g     =  mcx_debug_g

   ;  n_thread_g = mclx_set_threads_or_die(mediam, n_thread_l, i_group, n_group_G)

;fprintf(stderr, "%d %d %d\n", (int) n_thread_g, (int) n_thread_l, (int) n_group_G)
   ;  mcxIOopen(xfout, EXIT_ON_FAIL)

   ;  mx = mcx_get_data(xfmx_g, xfabc_g, xftab_g, &tab_g, TRUE)
   ;  mcxIOfree(&xfmx_g)
   ;  mclxAdjustLoops(mx, mclxLoopCBremove, NULL)

   ;  tabulator      =  calloc(N_COLS(mx), sizeof tabulator[0])
   ;  ecc_scratch    =  mclvCopy(NULL, mx->dom_rows)
                                       /* ^ used as ecc scratch: should have values 1.0 */

   ;  canonical = MCLV_IS_CANONICAL(mx->dom_cols)

   ;  if (rough && !mclxGraphCanonical(mx))
      mcxDie(1, mediam, "rough needs canonical domains")

   ;  if (rough)
      {  u8* rough_scratch    =  calloc(N_COLS(mx), sizeof rough_scratch[0])
      ;  long* rough_priority =  mcxAlloc(N_COLS(mx) * sizeof rough_priority[0], EXIT_ON_FAIL)
      ;  for (i=0;i<N_COLS(mx);i++)
         rough_priority[i] = 0
      ;  for (i=0;i<N_COLS(mx);i++)
         {  dim priority = 0
         ;  rough_it(mx, tabulator, i, rough_scratch, rough_priority, &priority)
      ;  }
         mcxFree(rough_scratch)
      ;  mcxFree(rough_priority)
   ;  }
      else if (n_thread_g == 0)
      ecc_compute(tabulator, mx, 0, 1, ecc_scratch)
   ;  else
      {  dim t = 0
      ;  mclx* scratchen            /* annoying UNIXen-type plural */
         =  mclxCartesian(mclvCanonical(NULL, n_thread_g, 1.0), mclvClone(mx->dom_rows), 1.0)

      ;  diam_data* data = mcxAlloc(n_thread_g * sizeof data[0], EXIT_ON_FAIL)

      ;  for (t=0;t<n_thread_g;t++)
         {  diam_data* d=  data+t
         ;  d->scratch  =  scratchen->cols+t
         ;  d->tabulator= tabulator
      ;  }

         mclxVectorDispatchGroup(mx, data, n_thread_g, diam_dispatch, n_group_G, i_group)
      ;  mcxFree(data)
      ;  mclxFree(&scratchen)
   ;  }

      if (list_nodes)
      fprintf(xfout->fp, "node\tdiam\n")

   ;  for (i=0;i<N_COLS(mx);i++)    /* report everything so that results can be collected */
      {  dim dd = tabulator[i]
      ;  sum += dd

      ;  if (list_nodes)
         {  long vid = mx->cols[i].vid
         ;  if (tab_g)
            {  const char* label = mclTabGet(tab_g, vid, NULL)
            ;  if (!label) mcxDie(1, mediam, "panic label %ld not found", vid)
            ;  fprintf(xfout->fp, "%s\t%ld\n", label, (long) dd)
         ;  }
            else
            fprintf(xfout->fp, "%ld\t%ld\n", vid, (long) dd)
      ;  }

         if (dd > thediameter)
         thediameter = dd
   ;  }

      if (!list_nodes && N_COLS(mx))
      {  sum /= N_COLS(mx)
      ;  fprintf
         (  xfout->fp
         ,  "%d\t%.3f\n"
         ,  (unsigned) thediameter
         ,  (double) sum
         )
   ;  }

      mcxIOfree(&xfout)
   ;  mclxFree(&mx)
   ;  mclvFree(&ecc_scratch)
   ;  mcxFree(tabulator)
   ;  return 0
;  }


mcxDispHook* mcxDispHookDiameter
(  void
)
   {  static mcxDispHook diameterEntry
   =  {  "diameter"
      ,  "diameter [options]"
      ,  diameterOptions
      ,  sizeof(diameterOptions)/sizeof(mcxOptAnchor) - 1

      ,  diameterArgHandle
      ,  allInit
      ,  diameterMain

      ,  0
      ,  0
      ,  MCX_DISP_MANUAL
      }
   ;  return &diameterEntry
;  }


void clean_up
(  SSPnode*    nodes
,  mclx*       pathmx
)
   {  dim ofs

   ;  for (ofs=0;ofs<N_COLS(pathmx);ofs++)
      {  dim i
      ;  mclv* layer = pathmx->cols+ofs
      ;  for (i=0;i<layer->n_ivps;i++)
         {  SSPnode* nd = nodes+layer->ivps[i].idx
         ;  mcxLink* lk = nd->nb_lft->next
         ;  nd->acc_wtd_local = 0
         ;  nd->n_paths_lft = 0.0
         ;  while (lk)
            {  mcxLink* lk2 = lk->next
            ;  mcxLinkRemove(lk)
            ;  lk = lk2
         ;  }
            lk = nd->nb_rgt->next
         ;  while (lk)
            {  mcxLink* lk2 = lk->next
            ;  mcxLinkRemove(lk)
            ;  lk = lk2
         ;  }
            nd->nb_lft->next = NULL
         ;  nd->nb_rgt->next = NULL
      ;  }
      }
   }


void add_scores
(  SSPnode*    nodes
,  mclx*       pathmx
)
   {  dim ofs
   ;  double delta = mod_up ? 0.0 : 1.0

   ;  for (ofs=0;ofs<N_COLS(pathmx);ofs++)
      {  dim i
      ;  mclv* layer = pathmx->cols+ofs
      ;  for (i=0;i<layer->n_ivps;i++)
         {  SSPnode* nd = nodes+layer->ivps[i].idx
         ;  if
            (  (include_ends_g || (nd->nb_lft->next && nd->nb_rgt->next))
            && nd->acc_wtd_local >= delta
            )
            nd->acc_wtd_global += (nd->acc_wtd_local - delta)
      ;  }
      }
   }


void compute_scores_up
(  SSPnode*    nodes
,  mclx*       pathmx
)
   {  dim ofs

   ;  for (ofs=1;ofs<N_COLS(pathmx);ofs++)
      {  dim i
      ;  mclv* layer = pathmx->cols+N_COLS(pathmx)-ofs
      ;  for (i=0;i<layer->n_ivps;i++)
         {  SSPnode* nd = nodes+layer->ivps[i].idx
         ;  mcxLink* lk = nd->nb_lft

         ;  while ((lk = lk->next))
            {  SSPnode* nd2 = lk->val
            ;  nd2->acc_wtd_local
               +=  nd->acc_wtd_local * nd2->n_paths_lft * 1.0 / nd->n_paths_lft
         ;  }
         }
      }
   }



void compute_paths_down
(  SSPnode*       nodes
,  const mclx*    pathmx
)
   {  dim ofs

   ;  for (ofs=0;ofs<N_COLS(pathmx);ofs++)
      {  dim i
      ;  mclv* layer = pathmx->cols+ofs
;if (debug_g) fprintf(stdout, "%d nodes in layer %d\n", (int) layer->n_ivps, (int) ofs)
      ;  for (i=0;i<layer->n_ivps;i++)
         {  SSPnode* nd = nodes+layer->ivps[i].idx
         ;  mcxLink* lk = nd->nb_rgt

         ;  nd->acc_wtd_local = 1.0

                                                            /* initialise to edge weight? */
         ;  if (!nd->n_paths_lft)
            nd->n_paths_lft = 1.0

         ;  while ((lk = lk->next))
            {  SSPnode* nd2 = lk->val
            ;  nd2->n_paths_lft += nd->n_paths_lft
         ;  }
         }
      }
   }


void lattice_print_nodes
(  mclx*    pathmx
,  SSPnode* nodes
)
   {  dim l
   ;  fprintf(stdout, "nodes: lattice has %ld layers\n", (long) N_COLS(pathmx))
   ;  for (l=0;l<N_COLS(pathmx);l++)
      {  dim i
      ;  mclv* layer = pathmx->cols+l
      ;  fprintf(stdout, "size=%ld", (long) layer->n_ivps)
      ;  for (i=0;i<layer->n_ivps;i++)
         {  SSPnode* nd = nodes + layer->ivps[i].idx
         ;  fprintf
            (  stdout
            ,  " %ld-(%ld)/%.2f"
            ,  (long) nd->node_idx
            ,  (long) nd->n_paths_lft
            ,  nd->acc_wtd_local
            )
      ;  }
         fputc('\n', stdout)
   ;  }
;  }



void lattice_print_edges
(  mclx*    pathmx
,  SSPnode* nodes
)
   {  dim l
   ;  fprintf(stdout, "edges: lattice has %ld layers\n", (long) N_COLS(pathmx))

   ;  for (l=0;l<N_COLS(pathmx);l++)
      {  mclv* layer = pathmx->cols+l
      ;  dim i
      ;  fprintf(stdout, "size=%ld", (long) layer->n_ivps)
      ;  for (i=0;i<layer->n_ivps;i++)
         {  SSPnode* nd = nodes + layer->ivps[i].idx
         ;  mcxLink* lk = nd->nb_rgt->next
         ;  while (lk)
            {  SSPnode* nd2 = lk->val
            ;  fprintf(stdout, " (%ld %ld)", (long) nd->node_idx, (long) nd2->node_idx)
            ;  lk = lk->next
         ;  }
         }
         fputc('\n', stdout)
   ;  }
;  }



void mclgSSPmakeLattice
(  mclx* pathmx
,  const mclx* mx
,  SSPnode* nodes
)
   {  dim i
#if 0
   ;  for (i=0;i<N_COLS(pathmx);i++)
      mclvaDump(pathmx->cols+i, stdout, MCLXIO_VALUE_GETENV, " ", 0)
#endif

   ;  for (i=0;i<N_COLS(pathmx);i++)
      {  dim v = 0
      ;  mclv* tails = pathmx->cols+i
      ;  mclv* heads = i < N_COLS(pathmx)-1 ? pathmx->cols+i+1 : NULL
      ;  mclv* relevant = mclvInit(NULL)

      ;  for (v=0;v<tails->n_ivps;v++)
         {  dim j
         ;  ofs lft_idx = tails->ivps[v].idx
         ;  mclv* nb = mclxGetVector(mx, lft_idx, EXIT_ON_FAIL, NULL)
         ;  if (heads)
            mcldMeet(nb, heads, relevant)

         ;  for (j=0;j<relevant->n_ivps;j++)
            {  ofs rgt_idx = relevant->ivps[j].idx
            ;  mcxLinkAfter(nodes[lft_idx].nb_rgt, nodes+rgt_idx)
            ;  mcxLinkAfter(nodes[rgt_idx].nb_lft, nodes+lft_idx)
         ;  }
         }
         mclvFree(&relevant)
   ;  }
   }



mclx* cttyFlood
(  const mclx* mx
,  SSPnode* nodes_unused   cpl__unused
,  ofs root
,  dim extent
)
   {  mclv* wave
   ;  mclx* pathmx = mclxAllocClone(mx)
   ;  mclv* scratch = mclvCopy(NULL, mx->dom_cols)

   ;  dim n_wave = 0

   ;  mclvInsertIdx(pathmx->cols+0, root, 1.0)
   ;  mclgUnionvInitNode2(scratch, root)
   ;  wave = mclvClone(pathmx->cols+0)
   ;  n_wave = 1

   ;  while (!extent || n_wave <= extent)
      {  mclv* wave2 = mclgUnionv2(mx, wave, NULL, SCRATCH_UPDATE, NULL, scratch)
; if (debug_g)
mclvaDump(wave2, stdout, MCLXIO_VALUE_GETENV, " ", MCLVA_DUMP_VID_OFF)
      ;  if (wave2->n_ivps)
         {  mclvFree(&wave)
         ;  wave = wave2
         ;  mclvCopy(pathmx->cols+n_wave, wave2)
         ;  n_wave++
      ;  }
         else
         {  mclvFree(&wave2)
         ;  break
      ;  }
      }

      mclvFree(&wave)
   ;  mclvResize(pathmx->dom_cols, n_wave)
   ;  mclvFree(&scratch)
   ;  return pathmx
;  }


static void ctty_compute
(  const mclx* mx
,  dim         offset
,  mclv*       ctty
)  
   {  SSPnode* nodes    =  mcxAlloc(N_COLS(mx) * sizeof nodes[0], EXIT_ON_FAIL)
   ;  mcxLink* src_link =  mcxListSource(N_COLS(mx), 0)
   ;  long vid          =  mx->cols[offset].vid
   ;  mclx* pathmx      =  NULL
   ;  dim i

   ;  for (i=0;i<N_COLS(mx);i++)
      {  nodes[i].node_idx =  i
      ;  nodes[i].acc_chr  =  0
      ;  nodes[i].acc_wtd_global  =  0.0
      ;  nodes[i].acc_wtd_local = 0.0
      ;  nodes[i].nb_lft   =  mcxLinkSpawn(src_link, NULL)
      ;  nodes[i].nb_rgt   =  mcxLinkSpawn(src_link, NULL)
      ;  nodes[i].n_paths_lft = 0
   ;  }

      pathmx = cttyFlood(mx, nodes, vid, extent_g)

   ;  mclgSSPmakeLattice(pathmx, mx, nodes)
   ;  if (debug_g)
         fprintf(stdout, "\nroot %ld\n", vid)
      ,  lattice_print_edges(pathmx, nodes)

#if 0
   ;  if (weighted_g)
      compute_paths_down_dijkstra(nodes, pathmx, mx)
#endif

   ;  compute_paths_down(nodes, pathmx)

   ;  compute_scores_up(nodes, pathmx)
   ;  add_scores(nodes, pathmx)
   ;  if (debug_g)
      lattice_print_nodes(pathmx, nodes)
   ;  clean_up(nodes, pathmx)
   ;  mclxFree(&pathmx)

   ;  for (i=0;i<N_COLS(mx);i++)
      {  ctty->ivps[i].val += nodes[i].acc_wtd_global
   ;  }

      mcxFree(nodes)
   ;  mcxListFree(&src_link, NULL)
;  }


typedef struct
{  mclv*    ctty
;
}  ctty_data   ;


static void ctty_dispatch
(  mclx* mx
,  dim i
,  void* data
,  dim thread_id
)
   {  ctty_data* d = ((ctty_data*) data) + thread_id
   ;  ctty_compute(mx, i, d->ctty)
;  }



static mcxstatus cttyMain
(  int          argc_unused      cpl__unused
,  const char*  argv_unused[]    cpl__unused
)  
   {  mclx* mx, *ctty
   ;  mcxIO* xfout = mcxIOnew(out_g, "w")
   ;  dim i, n_thread_g

   ;  mcxIOopen(xfout, EXIT_ON_FAIL)

   ;  n_thread_g = mclx_set_threads_or_die(mectty, n_thread_l, i_group, n_group_G)

   ;  mx = mcx_get_data(xfmx_g, xfabc_g, xftab_g, &tab_g, TRUE)
   ;  mcxIOfree(&xfmx_g)
   ;  mclxAdjustLoops(mx, mclxLoopCBremove, NULL)

   ;  ctty
      =  mclxCartesian(mclvCanonical(NULL, MCX_MAX(n_thread_g,1), 1.0), mclvClone(mx->dom_rows), 0.0)

   ;  debug_g     =  mcx_debug_g
   ;  progress_g  =  mcx_progress_g

   ;  if (n_thread_g == 0)
      for (i=0;i<N_COLS(mx);i++)
      ctty_compute(mx, i, ctty->cols+0)
   ;  else
      {  dim t = 0
      ;  ctty_data* data = mcxAlloc(n_thread_g * sizeof data[0], EXIT_ON_FAIL)
      ;  for (t=0; t<n_thread_g; t++)
         {  ctty_data* d  = data+t
         ;  d->ctty  =  ctty->cols+t
      ;  }
         mclxVectorDispatchGroup(mx, data, n_thread_g, ctty_dispatch, n_group_G, i_group)
      ;  mcxFree(data)
   ;  }

      if (ctty->cols[0].n_ivps != N_COLS(mx))
      mcxDie(1, mectty, "internal error, tabulator miscount")

                     /* add subtotals to first vector */
   ;  for (i=1;i<N_COLS(ctty);i++)
      {  mclv* vec = ctty->cols+i
      ;  dim j
      ;  if (vec->n_ivps != N_COLS(mx))
         mcxDie(1, mectty, "internal error, tabulator miscount")
      ;  for (j=0;j<vec->n_ivps;j++)
         ctty->cols[0].ivps[j].val += vec->ivps[j].val
   ;  }

                     /* and report first vector, optionally with labels */
      {  mclv* v = ctty->cols+0
      ;  fprintf(xfout->fp, "node\tctty\n")
      ;  for (i=0;i<v->n_ivps;i++)
         {  double ctt  =  v->ivps[i].val
         ;  long  vid   =  v->ivps[i].idx
         ;  if (tab_g)
            {  const char* label = mclTabGet(tab_g, vid, NULL)
            ;  if (!label) mcxDie(1, mectty, "panic label %ld not found", vid)
            ;  fprintf(xfout->fp, "%s\t%.8g\n", label, ctt)
         ;  }
            else
            fprintf(xfout->fp, "%ld\t%.8g\n",  vid, ctt)
      ;  }
      }

      mcxIOfree(&xfout)
   ;  mclxFree(&mx)
   ;  mclxFree(&ctty)
   ;  return 0
;  }


mcxDispHook* mcxDispHookCtty
(  void
)
   {  static mcxDispHook cttyEntry
   =  {  "ctty"
      ,  "ctty [options]"
      ,  cttyOptions
      ,  sizeof(cttyOptions)/sizeof(mcxOptAnchor) - 1

      ,  cttyArgHandle
      ,  allInit
      ,  cttyMain

      ,  0
      ,  0
      ,  MCX_DISP_MANUAL
      }
   ;  return &cttyEntry
;  }




