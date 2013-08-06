/*   (C) Copyright 1999, 2000, 2001, 2002, 2003, 2004, 2005 Stijn van Dongen
 *   (C) Copyright 2006, 2007, 2008, 2009, 2010, 2011  Stijn van Dongen
 *
 * This file is part of MCL.  You can redistribute and/or modify MCL under the
 * terms of the GNU General Public License; either version 3 of the License or
 * (at your option) any later version.  You should have received a copy of the
 * GPL along with MCL, in the file COPYING.
*/

#include <math.h>

#include "compose.h"

#include "util/compile.h"
#include "util/types.h"
#include "util/alloc.h"
#include "util/types.h"
#include "util/err.h"

typedef struct mclIOV
{  long     index
;  int      ref
;  double   value
;
}  mclIOV   ;


void*  mclIOVinit_v
(  void*   iovp
)
   {  mclIOV* iov = (mclIOV*) iovp
   ;  iov->index  = -1
   ;  iov->ref    = -1
   ;  iov->value  = -1.0
   ;  return iov
;  }


struct mclxComposeHelper
{  mclIOV*  iovs
;  int      n_iovs
;
}  ;


mclxComposeHelper* mclxComposePrepare
(  const mclMatrix*  mx1
,  const mclMatrix*  mx2_unused  cpl__unused
)
   {  mclxComposeHelper* ch
                  =     mcxRealloc
                        (  NULL, sizeof(mclxComposeHelper), EXIT_ON_FAIL)
   ;  ch->iovs    =     mcxNAlloc
                        (  N_ROWS(mx1) + 1
                        ,  sizeof(mclIOV)
                        ,  mclIOVinit_v
                        ,  EXIT_ON_FAIL
                        )
   ;  return ch
;  }


void mclxComposeRelease
(  mclxComposeHelper **chpp
)
   {  mclxComposeHelper* ch = *chpp
   ;  if (ch)
      {  mcxFree(ch->iovs)
      ;  mcxFree(ch)
      ;  *chpp = NULL
   ;  }
   }


mclVector* mclxVectorCompose
(  const mclMatrix*        mx
,  const mclVector*        vecs
,  mclVector*              vecd
,  mclxComposeHelper*      ch
)
   {  mclIvp*  facivp      =  vecs->ivps - 1
   ;  mclIvp*  facivpmax   =  vecs->ivps + vecs->n_ivps
   ;  int      n_entries   =  0
   ;  mclIOV*  iovs        =  ch->iovs
   ;  int      cleanup     =  0
   ;  mcxbool  canonical   =  mclxColCanonical(mx)
   ;  mclVector* vecprev   =  NULL
   ;  int n_cols           =  N_COLS(mx)

   ;  if (!ch)
         ch =  mclxComposePrepare(mx, NULL)
      ,  cleanup = 1

   ;  iovs[0].ref    =  -1
   ;  iovs[0].index  =  -1
   ;  iovs[0].value  =  -1.0

   ;  while (++facivp < facivpmax)
      {  mclVector*  mxvec
         =  canonical
            ?  (  facivp->idx < n_cols
                  ?  mx->cols+(facivp->idx)
                  :  NULL
               )
            :  mclxGetVector
               (  mx
               ,  facivp->idx
               ,  RETURN_ON_FAIL
               ,  vecprev
               )
      ;  int      i_iov    =  0
      ;  mclIvp*  colivp   =  mxvec ? mxvec->ivps + mxvec->n_ivps : NULL
      ;  double   facval   =  facivp->val

      ;  vecprev  = mxvec ? mxvec + 1 : NULL

      ;  if (!mxvec || !mxvec->n_ivps)
         continue

      ;  while (--colivp >= mxvec->ivps)
         {  long dstidx  =  colivp->idx

         ;  while(dstidx < iovs[i_iov].index)
            i_iov = iovs[i_iov].ref

           /*  now   dstidx >= iovs[i_iov].index
            *  fixme do I need to check sth here ?
            *  hum, the threshold value is -1, so should be ok.
           */

         ;  if (iovs[i_iov].index != dstidx)
            {  n_entries++
            ;  iovs[n_entries]   =  iovs[i_iov]
            ;  iovs[i_iov].index =  dstidx
            ;  iovs[i_iov].ref   =  n_entries
            ;  iovs[i_iov].value =  0.0
         ;  }

            iovs[i_iov].value   +=  facval * colivp->val
         ;  i_iov = iovs[i_iov].ref
         ;
         }
      }
      vecd = mclvResize(vecd, n_entries)

   ;  if (n_entries)
      {  int i_iov = 0
      ;  int i_ivp = n_entries

      ;  while (--i_ivp, iovs[i_iov].index >= 0)
         {  vecd->ivps[i_ivp].idx = iovs[i_iov].index
         ;  vecd->ivps[i_ivp].val = iovs[i_iov].value
         ;  i_iov = iovs[i_iov].ref
      ;  }
      }

      if (cleanup)
      mclxComposeRelease(&ch)
   ;  return vecd
;  }


mclMatrix* mclxCompose
(  const mclMatrix*  m1
,  const mclMatrix*  m2
,  int               maxDensity
)
   {  int            n_m2_cols   =  N_COLS(m2)
   ;  mclMatrix*     pr             =  0
   ;  mclxComposeHelper *ch         =  mclxComposePrepare(m1, m2)

   ;  pr   =   mclxAllocZero
               (  mclvCopy(NULL, m2->dom_cols)
               ,  mclvCopy(NULL, m1->dom_rows)
               )

   ;  if (pr)
      {  while (--n_m2_cols >= 0)
         {  mclxVectorCompose
            (  m1
            ,  m2->cols + n_m2_cols
            ,  pr->cols + n_m2_cols
            ,  ch
            )
         ;  if (maxDensity)
            mclvSelectHighestGT
            (  pr->cols + n_m2_cols
            ,  maxDensity
            )
      ;  }
      }
      mclxComposeRelease(&ch)
   ;  return pr
;  }


