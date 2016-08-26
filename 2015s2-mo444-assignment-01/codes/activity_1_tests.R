#------------------------------------------------
setwd("D:\\MO444\\2015s2-mo444-assignment-01")
#Read data set
data <- read.csv("data.csv")
plot(data)

#Dependent variable
y <- data$profit

#Independent variable
x <- data$population

#Add ones to x 
x <- cbind(1,x)

# initalize theta vector
theta<- c(0,0)

# Number of the observations
m <- nrow(x)

#Calculate cost
cost <- sum(((x%*%theta)- y)^2)/(2*m)

# Set learning parameter
alpha <- 0.001

#Number of iterations
iterations <- 1500

# updating thetas using gradient update
for(i in 1:iterations)
{
  theta[1] <- theta[1] - alpha * (1/m) * sum(((x%*%theta)- y))
  theta[2] <- theta[2] - alpha * (1/m) * sum(((x%*%theta)- y)*x[,2])
}

#Predict for areas of the 35,000 and 70,000 people
predict1 <- c(1,3.5) %*% theta
predict2 <- c(1,7) %*% theta




setwd(Sys.getenv("HOME"));

getwd()

library(mosaic)
house = read.csv("D:\\MO444\\2015s2-mo444-assignment-01\\house.csv", header=TRUE)
summary(house)

par(mfrow = c(1, 2))
plot(price~sqft+bedrooms, data=house, pch=19)
lm0 = lm(price~sqft+bedrooms, data=house)
abline(lm0,h=1,v=1)

summary(lm0)
coef(lm0)

## Setup up coordinate system (with x == y aspect ratio):
plot(c(-2,3), c(-1,5), type = "n", xlab = "x", ylab = "y", asp = 1)
## the x- and y-axis, and an integer grid
abline(h = 0, v = 0, col = "gray60")
text(1,0, "abline( h = 0 )", col = "gray60", adj = c(0, -.1))
abline(h = -1:5, v = -2:3, col = "lightgray", lty = 3)
abline(a = 1, b = 2, col = 2)
text(1,3, "abline( 1, 2 )", col = 2, adj = c(-.1, -.1))

## Simple Regression Lines:
require(stats)
sale5 <- c(6, 4, 9, 7, 6, 12, 8, 10, 9, 13)
plot(sale5)
abline(lsfit(1:10, sale5))
abline(lsfit(1:10, sale5, intercept = FALSE), col = 10) # less fitting

z <- lm(dist ~ speed, data = cars)
plot(cars)
abline(z) # equivalent to abline(reg = z) or
abline(coef = coef(z))

## trivial intercept model
abline(mC <- lm(dist ~ 1, data = cars)) ## the same as
abline(a = coef(mC), b = 0, col = "blue")





x<- c(1,2,3,4)
y<- c(1.6,4.4,5.5,8.3)
x.demean<-x-mean(x)
y.mean<-mean(y)
y.demean<-y-y.mean

# The model is fit as before with all parameters.
plot(x,y)
fit1<-lm(y~x) # includes intercept term
abline(fit1)
summary(fit1) # PRE = 0.9749
fit1.SSE<-sum(resid(fit1)^2) # SSE=0.578

fit2<-lm(y~x-1) # excludes intercept, as in the original example (forces the intercept to zero)
summary(fit2) # PRE = 0.9946
abline(fit2,col="blue")
fit2.SSE<-sum(resid(fit2)^2) # SSE=0.6596667

# In order to understand the comparison taking place in fit1
SSEc <-sum(y.demean^2) #SSE of a model predicting only the mean
SSEa <-fit1.SSE
fit1.PRE <-(SSEc-fit1.SSE)/SSEc   #   = 0.9749 as by summary(lm(fit1))
SSEc.noint <-sum(y^2) # =121.06
fit2.PRE<-(SSEc.noint-fit2.SSE)/SSEc.noint # = 0.994551 or 0.9946 as before




set.seed(1)      # for reproducible example
train <- data.frame(X1=sample(1:100,100),
                    X2=1e6*sample(1:100,100),
                    X3=1e-6*sample(1:100,100))

train$y <- with(train,2*X1 + 3*1e-6*X2 - 5*1e6*X3 + 1 + rnorm(100,sd=10))

fit  <- lm(y~X1+X2+X3,train)
summary(fit)

# scale the predictor variables to [0,1]
mins   <- sapply(train[,1:3],min)
ranges <- sapply(train[,1:3],function(x)diff(range(x)))
train.scaled <- as.data.frame(scale(train[,1:3],center=mins,scale=ranges))
train.scaled$y <- train$y
fit.scaled <- lm(y ~ X1 + X2 + X3, train.scaled)
summary(fit.scaled)

all.equal(fit,fit.scaled)

# create test dataset
test <- data.frame(X1=sample(-5:5,10),
                   X2=1e6*sample(-5:5,10),
                   X3=1e-6*sample(-5:5,10))
# predict y based on test data with un-scaled fit
pred   <- predict(fit,newdata=test)

# scale the test data using min and range from training dataset
test.scaled <- as.data.frame(scale(test[,1:3],center=mins,scale=ranges))

# predict y based on new data scaled, with fit from scaled dataset
pred.scaled   <- predict(fit.scaled,newdata=test.scaled)

all.equal(pred,pred.scaled)

summary(pred)

#------------------------------------------------
setwd("D:\\MO444\\2015s2-mo444-assignment-01")
#Read data set
data <- read.csv("data.csv")
plot(data)

#Dependent variable
y <- data$profit

#Independent variable
x <- data$population

#Add ones to x 
x <- cbind(1,x)

# initalize theta vector
theta<- c(0,0)

# Number of the observations
m <- nrow(x)

#Calculate cost
cost <- sum(((x%*%theta)- y)^2)/(2*m)

# Set learning parameter
alpha <- 0.001

#Number of iterations
iterations <- 1500

# updating thetas using gradient update
for(i in 1:iterations)
{
  theta[1] <- theta[1] - alpha * (1/m) * sum(((x%*%theta)- y))
  theta[2] <- theta[2] - alpha * (1/m) * sum(((x%*%theta)- y)*x[,2])
}

#Predict for areas of the 35,000 and 70,000 people
predict1 <- c(1,3.5) %*% theta
predict2 <- c(1,7) %*% theta
