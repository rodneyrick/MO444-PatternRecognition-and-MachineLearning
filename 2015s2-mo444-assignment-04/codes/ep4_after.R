train <- read.csv(file="D:\\MO444\\2015s2-mo444-assignment-04\\trat_200.csv", sep=",", header = FALSE, nrows=20000)
val <- read.csv(file="D:\\MO444\\2015s2-mo444-assignment-04\\trat_200.csv", sep=",", header = FALSE, nrows=20000, skip = 25001)



# original data
pca <- princomp(train[-1]) # principal components analysis using correlation matrix
pc.comp <- pca$scores
d <- as.data.frame(train$V1)
colnames(d) <- c("V1")
d <- cbind(d,pc.comp)

cut_off <- 0.75

t <- as.matrix(d[,-1])
vars <- apply(t, 2, var) #apply in each column
d <- as.data.frame(t[,vars > quantile(vars, cut_off)]) #get columns have more variance than 90%
d$V1 <- train[,1] # add column with activity

fmla <- as.formula(paste("V1 ~ ",paste(colnames(d[,-dim(d)[2]]),sep=" ", collapse = " + ")))

library(randomForest)
fit <- randomForest(fmla,data=d)
print(fit) # view results
# importance(fit) # importance of each predictor

# original data
pca <- princomp(val[-1]) # principal components analysis using correlation matrix
pc.comp <- pca$scores
d <- as.data.frame(val$V1)
colnames(d) <- c("V1")
d <- cbind(d,pc.comp)

t <- as.matrix(d[,-1])
vars <- apply(t, 2, var) #apply in each column
d <- as.data.frame(t[,vars > quantile(vars, cut_off)]) #get columns have more variance than 90%
d$V1 <- val[,1] # add column with activity

val.pred <- predict(fit, d[,-dim(d)[2]])
table(observed = val[,1], predicted = val.pred)

library(caret)
xtab <- table(val.pred, val[,1])

confusionMatrix(xtab)
confusionMatrix(val.pred, val[,1])

plot(fit, main = "25% dos atributos" )
legend("topright", colnames(fit$err.rate),col=1:4,cex=0.8,fill=1:4)


# rm(list = setdiff(ls(), lsf.str()))

# --------------------------------------------------------------
# Regression Tree Example
library(rpart)

pca <- princomp(train[-1])
pc.comp <- pca$scores
d <- as.data.frame(train$V1)
colnames(d) <- c("V1")
d <- cbind(d,pc.comp)

t <- as.matrix(d[,-1])
vars <- apply(t, 2, var) #apply in each column
d <- as.data.frame(t[,vars > quantile(vars, cut_off)]) #get columns have more variance than 90%
d$V1 <- train[,1] # add column with activity

# grow tree
fit <- rpart(fmla,data=d)

printcp(fit) # display the results
plot(fit)
plotcp(fit) # visualize cross-validation results
summary(fit) # detailed summary of splits

pca <- princomp(val[-1]) # principal components analysis using correlation matrix
pc.comp <- pca$scores
d <- as.data.frame(val$V1)
colnames(d) <- c("V1")
d <- cbind(d,pc.comp)

t <- as.matrix(d[,-1])
vars <- apply(t, 2, var) #apply in each column
d <- as.data.frame(t[,vars > quantile(vars, cut_off)]) #get columns have more variance than 90%
d$V1 <- val[,1] # add column with activity

val.pred <- predict(fit, d[,-dim(d)[2]], type = "class")
xtab <- table(val.pred, d[,dim(d)[2]])
confusionMatrix(xtab)

# create additional plots
par(mfrow=c(1,1)) # two plots on one page
rsq.rpart(fit) # visualize cross-validation results  

# plot tree
plot(fit, uniform=TRUE,
     main="Regression Tree for Mileage ")
text(fit, use.n=TRUE, all=TRUE, cex=.8)

# create attractive postcript plot of tree
post(fit, file = "D:\\MO444\\2015s2-mo444-assignment-04\\tree2.ps",
     title = "Regression Tree for Mileage")

# --------------------------------------------------------------
library(rattle)
library(rpart.plot)
library(RColorBrewer)

prp(fit)
fancyRpartPlot(fit, main = "Rpart com 100% das colunas para treino", sub = "Jogging: 0.4, LyingDown: 0.53, Sitting: 0.5, Stairs: 0.45, Standing: 0.52, Walking:0.61")

# --------------------------------------------------------------
# original data
pca <- princomp(train[-1]) # principal components analysis using correlation matrix
pc.comp <- pca$scores
d <- as.data.frame(train$V1)
colnames(d) <- c("V1")
d <- cbind(d,pc.comp)
fmla <- as.formula(paste("V1 ~ ",paste(colnames(d[,-1]),sep=" ", collapse = " + ")))

# http://www.ats.ucla.edu/stat/r/dae/logit.htm
mylogit <- glm(fmla, data = d, family = "binomial")

# original data
pca <- princomp(val[-1]) # principal components analysis using correlation matrix
pc.comp <- pca$scores
d <- as.data.frame(val$V1)
colnames(d) <- c("V1")
val <- cbind(d,pc.comp)
val.pred <- predict.glm(mylogit, newdata = val[,-1], type = "response")

xtab <- table(val.pred,val[,1])
confusionMatrix(xtab)


confusion.glm <- function(model, des.mat=NULL, response=NULL, cutoff=0.5) {
  if (missing(des.mat)) {
    prediction <- predict(model, type='response') > cutoff
    confusion  <- table(as.logical(model$y), prediction)
  } else {
    if (missing(response) || class(response) != "logical") {
      stop("Must give logical vector as response when des.mat given")
    }
    prediction <- predict(model, des.mat, type='response') > cutoff
    confusion  <- table(response, prediction)
  }
  confusion <- cbind(confusion,
                     c(1 - confusion[1,1] / rowSums(confusion)[1],
                       1 - confusion[2,2] / rowSums(confusion)[2]))
  confusion <- as.data.frame(confusion)
  names(confusion) <- c('FALSE', 'TRUE', 'class.error')
  return(confusion)
}

confusion.glm(mylogit, des.mat = val[,-1], response = val[,1], cutoff=0.9)

# ------------------------------------------------------------------------

library(Hmisc)
t <- var(as.matrix(val)) 

t <- as.matrix(d[,-1])
vars <- apply(t, 2, var)
d <- as.data.frame(t[,vars > quantile(vars, 0.95)])
names(d)

d$V1 <- train[,1]

# original data
pca <- princomp(train[-1]) # principal components analysis using correlation matrix
pc.comp <- pca$scores
d <- as.data.frame(train$V1)
colnames(d) <- c("V1")
d <- cbind(d,pc.comp)

fmla <- as.formula(paste("V1 ~ ",paste(colnames(d[,-16]),sep=" ", collapse = " + ")))
# ----------------------------------------------------------------------------------------

train <- read.csv(file="D:\\MO444\\2015s2-mo444-assignment-04\\trat_100.csv", sep=",", header = TRUE, nrows=25000)
val <- read.csv(file="D:\\MO444\\2015s2-mo444-assignment-04\\trat_100.csv", sep=",", header = FALSE, nrows=25000, skip = 25001)

# original data
pca <- princomp(train[-1]) # principal components analysis using correlation matrix
pc.comp <- pca$scores
d <- as.data.frame(train$V1)
colnames(d) <- c("V1")
d <- cbind(d,pc.comp)

cut_off <- 0.75

t <- as.matrix(d[,-1])
vars <- apply(t, 2, var) #apply in each column
d <- as.data.frame(t[,vars > quantile(vars, cut_off)]) #get columns have more variance than 90%
d$V1 <- train[,1] # add column with activity

fmla <- as.formula(paste("V1 ~ ",paste(colnames(d[,-dim(d)[2]]),sep=" ", collapse = " + ")))

## classification mode
# default with factor response:
library(e1071) # Support Vector Machines
fit <- svm(fmla, data = d)

print(fit) # view results
# importance(fit) # importance of each predictor

# original data
pca <- princomp(val[-1]) # principal components analysis using correlation matrix
pc.comp <- pca$scores
d <- as.data.frame(val$V1)
colnames(d) <- c("V1")
d <- cbind(d,pc.comp)

t <- as.matrix(d[,-1])
vars <- apply(t, 2, var) #apply in each column
d <- as.data.frame(t[,vars > quantile(vars, cut_off)]) #get columns have more variance than 90%
d$V1 <- val[,1] # add column with activity

val.pred <- predict(fit, d[,-dim(d)[2]])
table(observed = val[,1], predicted = val.pred)

library(caret)
xtab <- table(val.pred, val[,1])

confusionMatrix(xtab)

plot(fit,d[,1:2,76],fmla)

m <- as.matrix(d[,-76])

x <- data.frame(t(m[1,]))

library(moments)

# original data
pca <- princomp(train[-1]) # principal components analysis using correlation matrix
pc.comp <- pca$scores
d <- as.data.frame(train$V1)
colnames(d) <- c("V1")
d <- cbind(d,pc.comp)

fmla <- as.formula(paste("V1 ~ ",paste(colnames(ss[,-dim(ss)[2]]),sep=" ", collapse = " + ")))

library(randomForest)
fit <- randomForest(fmla,data=ss)
print(fit) # view results
# importance(fit) # importance of each predictor

# original data
pca <- princomp(val[-1]) # principal components analysis using correlation matrix
pc.comp <- pca$scores
d <- as.data.frame(val$V1)
colnames(d) <- c("V1")
d <- cbind(d,pc.comp)

s <- apply(d[,-1], 1, skewness)
k <- apply(d[,-1], 1, kurtosis)
m <- apply(d[,-1], 1, mean)
mi <- apply(d[,-1], 1, min)
ma <- apply(d[,-1], 1, max)

ss <- as.data.frame(s)
ss$k <- k
ss$m <- m
ss$mi <- mi
ss$ma <- ma
ss$V1 <- d[,1]

val.pred <- predict(fit, ss[,-1])
table(observed = val[,1], predicted = val.pred)

library(caret)
xtab <- table(val.pred, val[,1])

confusionMatrix(xtab)
confusionMatrix(val.pred, val[,1])

plot(fit, main = "100% dos atributos" )
legend("topright", colnames(fit$err.rate),col=1:4,cex=0.8,fill=1:4)


# -------------------------------------------------------------------------------
train <- read.csv(file="D:\\MO444\\2015s2-mo444-assignment-04\\trat_100.csv", sep=",", header = TRUE, nrows=20000)
val <- read.csv(file="D:\\MO444\\2015s2-mo444-assignment-04\\trat_100.csv", sep=",", header = FALSE, nrows=20000, skip = 25001)

# original data
pca <- princomp(train[,-1]) # principal components analysis using correlation matrix
pc.comp <- pca$scores
d <- as.data.frame(train$V1)
colnames(d) <- c("V1")
d <- cbind(d,pc.comp)

cut_off <- 0.75
t <- as.matrix(d[,-1])
vars <- apply(t, 2, var) #apply in each column
d <- as.data.frame(t[,vars > quantile(vars, cut_off)]) #get columns have more variance than 90%
d$V1 <- train[,1] # add column with activity

fft_train <- d[1,]

apply(d[1:20,], 1, function(x) {
  s <- as.numeric(as.vector(x[-target]))
  test <- fft(s)
  # extract magnitudes and phases
  magn <- Mod(test) # sqrt(Re(test)*Re(test)+Im(test)*Im(test))
  # plot(test, magn)
  new_row <- c(x[target],magn)
  fft_train <- rbind(fft_train, new_row)
})

plot(fft_train[1,])

