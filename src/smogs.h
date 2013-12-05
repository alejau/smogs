#ifndef _smogs_SMOGS_H
#define _smogs_SMOGS_H

#include <Rcpp.h>

/*model values*/
#define SMOGS_LINEAR 0
#define SMOGS_LOGISTIC 1
#define SMOGS_MODEL_COUNT 2

RcppExport{
  SEXP smogs(SEXP X, SEXP y, SEXP nk, SEXP groups, SEXP lambda, SEXP corrfactor, SEXP model, SEXP conveps, SEXP eps, SEXP maxiter,SEXP maxitersg);
  SEXP sogl(SEXP X, SEXP y, SEXP n, SEXP groups, SEXP lambda, SEXP model, SEXP conveps, SEXP eps, SEXP maxiter,SEXP maxitersg);
}

#endif
