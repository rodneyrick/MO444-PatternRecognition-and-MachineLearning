# Objective
# Explore linear regression alternatives and come up with the best possible model to the problems, avoiding overfitting. In particular, predict the release year of a song from audio features. Songs are mostly western, commercial tracks ranging from 1922 to 2011, with a peak in the year 2000s.
# 
# Activities
# 
# 1. Perform linear regression as the baseline (first solution) and devise LR-based alternative (more powerful) solutions.
# 2. Use the specified train/test data for providing your results and avoid overfitting. 
# 3. Devise and test more complex models. 
# 4. Plot the cost function vs. number of iterations in the training set and analyze the model complexity. What are the conclusions? What are the actions after such analyses? 
# 5. Use different Gradient Descent learning rates when optimizing. Compare the GD-based solutions with Normal Equations if possible (perhaps you should try with smaller sample sizes for this task). What are the conclusions? 
# 6. Prepare a 4-page (max.) report with all your findings. It is UP TO YOU to convince the reader that you dominate the regression subject and the choices related to this particular subject. 
# 
# 
# Dataset
# This data is a subset of the Million Song Dataset: http://labrosa.ee.columbia.edu/millionsong/ a collaboration between LabROSA (Columbia University) and The Echo Nest. Prepared by T. Bertin-Mahieux <tb2332 '@' columbia.edu>
#   
#   Data Set Information:
#   You should respect the following train / test split:
#   train: first 463,715 examples
# test: last 51,630 examples
# 
# It avoids the 'producer effect' by making sure no song from a given artist ends up in both the train and test set.
# 
# Attribute Information:
#   90 attributes, 12 = timbre average, 78 = timbre covariance. The first value is the year (target), ranging from 1922 to 2011. Features extracted from the 'timbre' features from The Echo Nest API. We take the average and covariance over all 'segments', each segment being described by a 12-dimensional timbre vector.
# 
# The datasets are available at: http://www.ic.unicamp.br/~rocha/teaching/2015s2/mo444/assignments/2015s2-mo444-assignment-01.zip
# MD5 (2015s2-mo444-assignment-01.zip) = a93627a7cfe154141d51d18962c1e9d4
# 
# Deadline 
# Wednesday, September 9th in the beginning of the class. There will be no deadline extension. 
# 
# Submission
# Bring your 4-page printed report and submit during class on the deadline day. This activity is INDIVIDUAL and not in teams. 



mydata = read.table("D:\\MO444\\2015s2-mo444-assignment-01\\YearPredictionMSD.txt",sep=",", header=FALSE,nrow=2000)

mydata.random = mydata[-1]

summary(mydata.random)


for (i in 1:ncol(mydata.random)) {
  c = mydata.random[i]
  c = (c - min(c)) / (max(c)-min(c))
  mydata.random[i] = c*100;
}


xnam <- paste(names(mydata.random[-1]), sep="")
fmla <- as.formula(paste(names(mydata.random[1])," ~ ", paste(xnam, collapse= "+")))
fmla

fit = lm(fmla, data=mydata.random)
summary(fit)

d = data.frame(data.frame(fit$coefficients[-1]),data.frame(xnam))
colnames(d) <- c("coefs", "vars")

line = mydata.random[1,]
line = t(line)

col = fit$coefficients[-1]*line

View(col)
pri = (t(mydata.random)*mydata.random)^1
dim(pri)

((t(mydata.random)*mydata.random)^-1)*t(mydata.random)*mydata[,1]

xnam <- paste("(",d$coefs[which(d$coefs > 0.2)],"*",d$vars[which(d$coefs > 0.2)],")", sep="")
fmla <- as.formula(paste(names(mydata.random[1])," ~ ", paste(xnam, collapse= "+")))
fmla

mydata.random[,0]

fit = lm(fmla , data=mydata.random)
summary(fit)



get_stars = function(fit,variables_names,variables_influences = -1) {
  p = fit[[1]];
  p = p[-length(p)];
  stars = findInterval(p, c(0, 0.001, 0.01, 0.05, 0.1))
  codes = c("***" , "**","*", ".", " ");
  # codes[stars];
  df1 <- data.frame(variables_names);
  df2 <- data.frame(stars);
  myList <- data.frame(df1, df2);
  if(variables_influences == -1){
    return(myList)
  }
  else{
    return(myList[which(myList$stars < variables_influences), ])
  }
  
}

d$stars<2

d = get_stars(fit, xnam,2)

d[which(d$stars<2), ]


test.summary <- summary(aov(fmla + Error(grouping.factor / iv1 ), data = df))
p <- test.summary[[2]][[1]][["Pr(>F)"]][1]


data.frame(summary(fit)$coef[summary(fit)$coef[,4] <= .5, 4])

pvals


d<-capture.output(summary(fit,multivariate=F))

d[1]

plot(fmla, mydata.random)
abline(fit)

##  plot.new() skips a position.
plot.new()

# xnam <- paste("x", 1:25, sep="")
# fmla <- as.formula(paste("y ~ ", paste(xnam, collapse= "+")))
# fmla


y <- c(1,4,6)
d <- data.frame(y = y, x1 = c(4,-1,3), x2 = c(3,9,8), x3 = c(4,-4,-2))
mod <- lm(y ~ ., data = d)

Y <- (log(1/((X1^(-theta_real) + X2^(-theta_real))))/log(theta_real))

plot(y~x1+x2^2, mydata.random)
plot(res1[1,], log10(res1[2,]), type = "l")

abline(fit)

ssq(fit)

# get data 
rm(list = ls(all = TRUE)) # make sure previous work is clear
ls()
x0 <- c(1,1,1,1,1) # column of 1's
x1 <- c(1,2,3,4,5) # original x-values

# create the x- matrix of explanatory variables

x <- as.matrix(cbind(x0,x1))

# create the y-matrix of dependent variables

y <- as.matrix(c(3,7,5,11,14))
m <- nrow(y)

# implement feature scaling
x.scaled <- x
x.scaled[,2] <- (x[,2] - mean(x[,2]))/sd(x[,2])

# analytical results with matrix algebra
solve(t(x)%*%x)%*%t(x)%*%y # w/o feature scaling
solve(t(x.scaled)%*%x.scaled)%*%t(x.scaled)%*%y # w/ feature scaling

# results using canned lm function match results above
summary(lm(y ~ x[, 2])) # w/o feature scaling
summary(lm(y ~ x.scaled[, 2])) # w/feature scaling

# define the gradient function dJ/dtheata: 1/m * (h(x)-y))*x where h(x) = x*theta
# in matrix form this is as follows:
grad <- function(x, y, theta) {
  gradient <- (1/m)* (t(x) %*% ((x %*% t(theta)) - y))
  return(t(gradient))
}

# define gradient descent update algorithm
grad.descent <- function(x, maxit){
  theta <- matrix(c(0, 0), nrow=1) # Initialize the parameters
  
  alpha = .05 # set learning rate
  for (i in 1:maxit) {
    theta <- theta - alpha  * grad(x, y, theta)   
  }
  return(theta)
}


# results without feature scaling
print(grad.descent(x,1000))

# results with feature scaling
print(grad.descent(x.scaled,1000))

# ----------------------------------------------------------------------- 
# cost and convergence intuition
# -----------------------------------------------------------------------

# typically we would iterate the algorithm above until the 
# change in the cost function (as a result of the updated b0 and b1 values)
# was extremely small value 'c'. C would be referred to as the set 'convergence'
# criteria. If C is not met after a given # of iterations, you can increase the
# iterations or change the learning rate 'alpha' to speed up convergence

# get results from gradient descent
beta <- grad.descent(x,1000)

# define the 'hypothesis function'
h <- function(xi,b0,b1) {
  b0 + b1 * xi 
}

# define the cost function   
cost <- t(mat.or.vec(1,m))
for(i in 1:m) {
  cost[i,1] <-  (1 /(2*m)) * (h(x[i,2],beta[1,1],beta[1,2])- y[i,])^2 
}

totalCost <- colSums(cost)
print(totalCost)

# save this as Cost1000
cost1000 <- totalCost

# change iterations to 1001 and compute cost1001
beta <- (grad.descent(x,1001))
cost <- t(mat.or.vec(1,m))
for(i in 1:m) {
  cost[i,1] <-  (1 /(2*m)) * (h(x[i,2],beta[1,1],beta[1,2])- y[i,])^2 
}
cost1001 <- colSums(cost)

# does this difference meet your convergence criteria? 
print(cost1000 - cost1001)








#  ----------------------------------------------------------------------------------
# |PROGRAM NAME: gradient_descent_R
# |DATE: 11/27/11
# |CREATED BY: MATT BOGARD 
# |PROJECT FILE:              
# |----------------------------------------------------------------------------------
# | PURPOSE: illustration of gradient descent algorithm
# | REFERENCE: adapted from : http://www.cs.colostate.edu/~anderson/cs545/Lectures/week6day2/week6day2.pdf                
# | 
#  ---------------------------------------------------------------------------------

xs <- seq(0,4,len=20) # create some values

# define the function we want to optimize

f <-  function(x) {
  1.2 * (x-2)^2 + 3.2
}

# plot the function 
plot(xs , f (xs), type="l",xlab="x",ylab=expression(1.2(x-2)^2 +3.2))

# calculate the gradeint df/dx

grad <- function(x){
  1.2*2*(x-2)
}


# df/dx = 2.4(x-2), if x = 2 then 2.4(2-2) = 0
# The actual solution we will approximate with gradeint descent
# is  x = 2 as depicted in the plot below

lines (c (2,2), c (3,8), col="red",lty=2)
text (2.1,7, "Closedform solution",col="red",pos=4)


# gradient descent implementation
x <- 0.1 # initialize the first guess for x-value
xtrace <- x # store x -values for graphing purposes (initial)
ftrace <- f(x) # store y-values (function evaluated at x) for graphing purposes (initial)
stepFactor <- 0.6 # learning rate 'alpha'
for (step in 1:100) {
  x <- x - stepFactor*grad(x) # gradient descent update
  xtrace <- c(xtrace,x) # update for graph
  ftrace <- c(ftrace,f(x)) # update for graph
}

lines ( xtrace , ftrace , type="b",col="blue")
text (0.5,6, "Gradient Descent",col="blue",pos= 4)

# print final value of x
print(x) # x converges to 2.0


##  Open a new default device.

get( getOption( "device" ) )()

##  Set up plotting in two rows and three columns, plotting along rows first.
par( mfrow = c( 2, 3 ) )

##  The first plot is located in row 1, column 1:
plot( rnorm( n = 10 ), col = "red", main = "plot 1", cex.lab = 1.1 )

##  The second plot is located in row 1, column 2:
plot( runif( n = 10 ), col = "blue", main = "plot 2", cex.lab = 1.1 )

##  The third plot is located in row 1, column 3:
plot( rt( n = 10, df = 8 ), col = "springgreen4", main = "plot 3",
      cex.lab = 1.1 )

##  The fourth plot is located in row 2, column 1:
plot( rpois( n = 10, lambda = 2 ), col = "black", main = "plot 4",
      cex.lab = 1.1 )


##  The fifth plot is located in row 2, column 3:
plot( rf( n = 10, df1 = 4, df2 = 8 ), col = "gray30", main = "plot 5",
      cex.lab = 1.1 )

