setwd("~/Desktop/MO444/2015s2-mo444-assignment-01")

getwd()
source("~/Desktop/MO444/2015s2-mo444-assignment-01/activity_1_functions.R")

# load data
data <- load_data(is_all_data=FALSE, limit=50000)

# training
train <- normalize_data(data[1:10000,])
# test
test <- normalize_data(data[10000:nrow(data),])

theta <- rep(c(0),each=90)
train.nrows <- nrow(train)
test.nrows <- nrow(test)

ncol(train[-1])
nrow(theta)

x <- 1:4
(z <- x %*% x)    # scalar ("inner") product (1 x 1 matrix)

y <- diag(x)
z <- matrix(1:12, ncol = 3, nrow = 4)
y %*% z
y %*% x
x %*% z
rm(z,x,y,theta)

cost <- sum(((train[-1]%*%theta)-train[1])^2)/(2*train.nrows)

#---------------------------------------------------------------------
# load data
data <- load_data(is_all_data=TRUE)

x <- data[unlist(tapply(1:nrow(data),data$V1,function(x) sample(x,10,replace = False))),]
rm(x,freq_data)

freq_data <- data.frame(table(x[1]))

freq_data <- data.frame(table(data[1]))

summary(data[1])

freq_data <- data.frame(table(data[1]))
freq_data$quantidade <- table(data[1])

table(data[1])


#load the iris data
data(iris)

# this data has 150 rows
nrow(iris)

# look at the first few
head(iris)

# splitdf function will return a list of training and testing sets
splitdf <- function(dataframe, seed=NULL) {
  if (!is.null(seed)) set.seed(seed)
  index <- 1:nrow(dataframe)
  trainindex <- sample(index, trunc(length(index)/2))
  trainset <- dataframe[trainindex, ]
  testset <- dataframe[-trainindex, ]
  list(trainset=trainset,testset=testset)
}

#apply the function
splits <- splitdf(data, seed=808)

#it returns a list - two data frames called trainset and testset
str(splits)

# there are 75 observations in each data frame
lapply(splits,nrow)

#view the first few columns in each data frame
lapply(splits,head)

# save the training and testing sets as data frames
training <- splits$trainset
testing <- splits$testset


########### Optional: apply to iris data using randomForest ###########

#load the randomForest library. if you havent installed it, run the next line
#install.packages("randomForest")
library(randomForest)

#fit the randomforest model
model <- randomForest(Sepal.Length~., 
                      data = training, 
                      importance=TRUE,
                      keep.forest=TRUE
)
print(model)

#what are the important variables (via permutation)
varImpPlot(model, type=1)

#predict the outcome of the testing data
predicted <- predict(model, newdata=testing[ ,-1])

# what is the proportion variation explained in the outcome of the testing data?
# i.e., what is 1-(SSerror/SStotal)
actual <- testing$Sepal.Length
rsq <- 1-sum((actual-predicted)^2)/sum((actual-mean(actual))^2)
print(rsq)


