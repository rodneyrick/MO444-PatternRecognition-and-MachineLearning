# install, load package
# https://beckmw.wordpress.com/tag/neural-network/
library(NeuralNetTools)

# create model
library(neuralnet)
AND <- c(rep(0, 7), 1)
OR <- c(0, rep(1, 7))
binary_data <- data.frame(expand.grid(c(0, 1), c(0, 1), c(0, 1)), AND, OR)
mod <- neuralnet(AND + OR ~ Var1 + Var2 + Var3, 
                 binary_data,
                 hidden = c(6, 12, 8), 
                 rep = 10, 
                 err.fct = 'ce', linear.output = FALSE)

# plotnet
par(mar = numeric(4), family = 'serif')
plotnet(mod, alpha = 0.6)

# ----------------------------------------------------
# https://beckmw.wordpress.com/tag/neural-network/
# https://beckmw.wordpress.com/2013/11/14/visualizing-neural-networks-in-r-update/
# https://beckmw.wordpress.com/2013/03/04/visualizing-neural-networks-from-the-nnet-package/
library(clusterGeneration)

seed.val<-2
set.seed(seed.val)

num.vars<-8
num.obs<-1000

#input variables
cov.mat<-genPositiveDefMat(num.vars,covMethod=c("unifcorrmat"))$Sigma
rand.vars<-mvrnorm(num.obs,rep(0,num.vars),Sigma=cov.mat)

#output variables
parms<-runif(num.vars,-10,10)
y1<-rand.vars %*% matrix(parms) + rnorm(num.obs,sd=20)
parms2<-runif(num.vars,-10,10)
y2<-rand.vars %*% matrix(parms2) + rnorm(num.obs,sd=20)

#final datasets
rand.vars<-data.frame(rand.vars)
resp<-data.frame(y1,y2)
names(resp)<-c('Y1','Y2')
dat.in<-data.frame(resp,rand.vars)

#nnet function from nnet package
library(nnet)
set.seed(seed.val)
mod1<-nnet(rand.vars,resp,data=dat.in,size=10,linout=T)

#neuralnet function from neuralnet package, notice use of only one response
library(neuralnet)
form.in<-as.formula('Y1~X1+X2+X3+X4+X5+X6+X7+X8')
set.seed(seed.val)
mod2<-neuralnet(form.in,data=dat.in,hidden=10)

#mlp function from RSNNS package
library(RSNNS)
set.seed(seed.val)
mod3<-mlp(rand.vars, resp, size=10,linOut=T)

#import the function from Github
library(devtools)
library(roxygen2)
library(downloader)
library(reshape)
source_url('https://gist.githubusercontent.com/fawda123/7471137/raw/466c1474d0a505ff044412703516c34f1a4684a5/nnet_plot_update.r')

#plot each model
plot.nnet(mod1)
plot.nnet(mod2)
plot.nnet(mod3)
