\name{smogs}
\alias{smogs}
\title{
Sparse Multitask Overlap Group Selection
}
\description{
Fit a sparse (penalized) model for multiple tasks by selecting groups of features across tasks. The groups can be overlapping and individual features set to zero within groups. 
}
\usage{
smogs(X, y, tasks, groups, lambda = NULL, nlambda = 20, model = "linear", standardize = T, conv.eps= 1e-3, eps = 1e-6, maxiter = 100, maxiter.shotgun = 300)	
}
\arguments{
\item{X}{feature matrix of n x p real numbers where n is the total number of replicates (for all tasks), and p is the number of predictors (features). The order of the rows in this matrix must match the task indicator.}
\item{y}{response vector of n real numbers. The responses must be ordered as given in the task indicator.}
\item{tasks}{indicator vector, e.g. c("A","A","B","B","B"), which shows the task each observation belongs to.}
\item{groups}{matrix of p x L integers (booleans) where L is the number of groups. Indicates which genes belong to which groups.}
\item{lambda}{penalty parameter. If not given, a lambda sequence will be calculated.}
\item{nlambda}{number of lambda values (only used if lambda is NULL).}
\item{model}{"linear" for gaussian responses or "logistic" for binomial responses.}
\item{standardize}{boolean value which determines whether the variables should be standardized or not.}
\item{conv.eps}{positive real number which sets the convergency threshold.}
\item{eps}{positive real number which sets the convergency threshold for internal functions.}
\item{maxiter}{positive integer which sets the maximum number of iterations.}
\item{maxiter.shotgun}{positive integer which sets the maximum number of iterations used in the shotgun library.}
}

\author{
Alexandra Jauhiainen and Karl Landström
}
\references{
Shotgun C++ package: http://www.select.cs.cmu.edu/projects/shotgun/
}
\examples{
	
require(smogs)	
set.seed(231456)
## set up parameters (small problem)
n <- 100	   # replicates in each task
p <- 21		   # predictors
L <- 4		   # groups
K <- 3		   # tasks

##set up groups for genes (predictors)
groups <- matrix(rep(c(1,0,1,0,1,0,1), times=c(6,20,6,20,6,20,6)), nrow=p,ncol=L)
rownames(groups)<-paste('feat',1:p,sep='');colnames(groups)<-paste('group',1:L,sep='')

## generate X (feature) matrix
X <- array(rnorm(n*p*K), dim=c(n,p,K))

## generate true regression coefficients	
w <- matrix(0,nrow=p,ncol=K,dimnames=list(paste('feat',1:p,sep=''),paste('task',1:K,sep='')))
w[groups[,1]+groups[,2]>0,]<-runif(K*sum(groups[,1]+groups[,2]>0),min=0.2,max=2.5)*sample(c(-1,1),size=K*sum(groups[,1]+groups[,2]>0),replace=T ); w[1:5,3]<-0; w[9,1]<-0

##generate linear responses
y<-NULL
for(k in 1:K){
  y <- cbind(y, X[,,k] \%*\% w[,k] + rnorm(n,0,3))
}	

##reformat data
y<-as.numeric(y)
Xtemp<-NULL
for(k in 1:K){Xtemp<-rbind(Xtemp, X[,,k])}
X<-Xtemp
	
##make task indicator vector
tasks<-rep(LETTERS[1:K],each=n)

#output SNR
for(i in 1:K){
  cat(sprintf("Signal-to-noise ratio, task \%d: \%0.3f\n", i, w[,i]\%*\%w[,i]/9))
}

fit <- smogs(X,y,tasks,groups)
}