train <- read.csv(file="D:\\MO444\\2015s2-mo444-assignment-04\\trat_100.csv", sep=",", header = TRUE, nrows=25000)

# train <- unique(train)
# 
# write.table(train, file = "D:\\MO444\\2015s2-mo444-assignment-04\\trat_100.csv", 
#             sep = ",", row.names = FALSE, nrows=25000)

source("ep4_functions.R")

# pca_func <- function(dataset, target_idx=-1, target="V1")
# cutt_off_columns <- function(dataset, target_idx=-1, cut_off=0.90)
# get_formula <- function(dataset, target="V1", target_idx=-1)

train.pca <- pca_func(train, target_idx=-1, target="V1")
train.pca <- cutt_off_columns(train.pca, target_idx=-1, cut_off=0.90)
fmla <- get_formula(train.pca, target="V1", target_idx=-1)


# create a model usign random forest
library(randomForest)
fit <- randomForest(fmla,data=train.pca)
print(fit) # view results
importance(fit) # importance of each predictor

val <- read.csv(file="D:\\MO444\\2015s2-mo444-assignment-04\\trat_100.csv", sep=",", header = FALSE, nrows=25000, skip = 25001)

val.pca <- pca_func(val, target_idx=-1, target="V1")

t <- as.matrix(val.pca[,-1])
vars <- apply(t, 2, var) #apply in each column
d <- as.data.frame(t[,vars > quantile(vars, 0.90)]) #get columns have more variance than 90%
d$V1 <- dataset[,1] # add column with activity
d

# predict class
val.pred <- predict(fit, newdata=val.pca[,-31])
table(observed = d[,1], predicted = val.pred)

library(caret)
xtab <- table(val.pred, val[,1])
confusionMatrix(xtab)
confusionMatrix(val.pred, val[,1])

# -------------------------------------------------------------------------------------
lm.fit <- glm(medv~., data=train)
summary(lm.fit)
pr.lm <- predict(lm.fit,test)

xtab <- table(val.pred, val[,1])
confusionMatrix(xtab)
confusionMatrix(val.pred, val[,1])

# ------------------------------------------------------------------------------------#

train <- read.csv(file="D:\\MO444\\2015s2-mo444-assignment-04\\train_100.csv", 
                  sep=",", header = FALSE, nrows=300)

# original data
pca <- princomp(train[-1]) # principal components analysis using correlation matrix
pc.comp <- pca$scores
d <- as.data.frame(train$V1)
colnames(d) <- c("V1")
d <- cbind(d,pc.comp)

t <- as.matrix(d[,-1])
vars <- apply(t, 2, var) #apply in each column
d <- as.data.frame(t[,vars > quantile(vars, 0.90)]) #get columns have more variance than 90%
names(d)
d$V1 <- train[,1] # add column with activity

fmla <- as.formula(paste("V1 ~ ",paste(colnames(d[,-31]),sep=" ", collapse = " + ")))
fmla <- as.formula(paste(" ~ ",paste(colnames(d[,-31]),sep=" ", collapse = " + ")))

library(neuralnet)

m <- model.matrix(fmla, data = d)
head(m)

nn <- neuralnet(fmla,data=d,hidden=c(5,3),linear.output=T)
plot(nn)

require(nnet)
targets<-class.ind( d[,31] )
fit<-nnet(d[,-31],targets,size=10,linout=T)

val <- read.csv(file="D:\\MO444\\2015s2-mo444-assignment-04\\train_100.csv", 
                sep=",", header = FALSE, nrows=500, skip=30000)
# validation
pca <- princomp(val[-1])
pc.comp <- pca$scores
d <- as.data.frame(val$V1)
colnames(d) <- c("V1")
d <- cbind(d,pc.comp)

t <- as.matrix(d[,-1])
vars <- apply(t, 2, var) #apply in each column
d <- as.data.frame(t[,vars > quantile(vars, 0.90)]) #get columns have more variance than 90%
names(d)
d$V1 <- val[,1] # add column with activity

val.pred <- predict(fit,val[,-31])

xtab <- table(val.pred, val[,31])
confusionMatrix(xtab)
confusionMatrix(val.pred, val[,1])

# predict class
val.pred <- predict(fit, d)
table(observed = d[,1], predicted = val.pred)

library(caret)
xtab <- table(val.pred, val[,1])
confusionMatrix(xtab)
confusionMatrix(val.pred, val[,1])

# ------------------------------------------------------------------------------------#
train <- read.csv(file="D:\\MO444\\2015s2-mo444-assignment-04\\train_100.csv", 
                  sep=",", header = FALSE, nrows=300)

# original data
pca <- princomp(train[-1]) # principal components analysis using correlation matrix
pc.comp <- pca$scores
d <- as.data.frame(train$V1)
colnames(d) <- c("V1")
d <- cbind(d,pc.comp)

t <- as.matrix(d[,-1])
vars <- apply(t, 2, var) #apply in each column
d <- as.data.frame(t[,vars > quantile(vars, 0.90)]) #get columns have more variance than 90%
names(d)
d$V1 <- train[,1] # add column with activity

fmla <- as.formula(paste("V1 ~ ",paste(colnames(d[,-31]),sep=" ", collapse = " + ")))

fit <- glm(fmla, data = d, family = "binomial")

val <- read.csv(file="D:\\MO444\\2015s2-mo444-assignment-04\\train_100.csv", 
                sep=",", header = FALSE, nrows=500, skip=30000)
# validation
pca <- princomp(val[-1])
pc.comp <- pca$scores
d <- as.data.frame(val$V1)
colnames(d) <- c("V1")
d <- cbind(d,pc.comp)

# predict class
val.pred <- predict(fit, d)
table(observed = d[,1], predicted = val.pred)

library(caret)
xtab <- table(val.pred, d[,1])
confusionMatrix(xtab)
confusionMatrix(val.pred, d[,1])

newdata1$rankP <- predict(mylogit, newdata = newdata1, type = "response")




