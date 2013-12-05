\name{sogl}
\alias{sogl}
\title{
Sparse Overlap Group Lasso
}
\description{
Fit a sparse version of the group lasso, where groups are allowed to overlap.
}
\usage{
sogl(X, y, groups, lambda = NULL, nlambda = 20, model = "linear", standardize = T, conv.eps= 1e-3, eps = 1e-6, maxiter = 100, maxiter.shotgun = 300)	
}
\arguments{
\item{X}{feature matrix of n real numbers where n is the number of replicates and p is the number of predictors (features).}
\item{y}{response vector of n real numbers}
\item{groups}{matrix of p x L integers where L is the number of groups. Indicates which genes belong to which groups.}
\item{lambda}{penalty parameter. If not given, a lambda sequence will be calculated.}
\item{nlambda}{number of lambda values (only used if lambda is NULL).}
\item{model}{"linear" for gaussian responses or "logistic" for binomial responses.}
\item{standardize}{boolean value which determines whether the variables should be standardized or not.}
\item{conv.eps}{positive real number which sets the convergency threshold.}
\item{eps}{positive real number which sets the convergency threshold for internal functions.}
\item{maxiter}{positive integer which sets the maximum number of iterations.}
\item{maxiter.shotgun}{positive integer which sets the maximum number of iterations used in the shotgun library}
}

\author{
Alexandra Jauhiainen and Karl Landström
}
\references{
Shotgun C++ package: http://www.select.cs.cmu.edu/projects/shotgun/
}
\examples{
require(smogs)	

set.seed(213456)
## set up parameters (small problem)
n <- 100	  	# replicates
p <- 21		   	# predictors
L <- 4		   	# groups

##set up groups for genes (predictors)
groups <- matrix(rep(c(1,0,1,0,1,0,1), times=c(6,20,6,20,6,20,6)), nrow=p,ncol=L)
rownames(groups)<-paste('feat',1:p,sep='');colnames(groups)<-paste('group',1:L,sep='')

## generate X (feature) matrix
X <- matrix(rnorm(n*p), nr=n,nc=p)

## generate true regression coefficients	
nz <- matrix(rep(c(T,F,T, F), times=c(8, 1 ,2, 10)), ncol=1)
w <- matrix(runif(p,min=0.2,max=2.5)*sample(c(-1,1), p, replace=T),nrow=p,ncol=1)
w[!nz]<- 0

##generate linear responses
y <- X %*% w + rnorm(n,0,2)

fit <- sogl(X,y,groups)

}
