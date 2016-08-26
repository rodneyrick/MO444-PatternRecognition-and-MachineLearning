# -------------------------------------------------------------------------------

nn <- names(train)
colnames(train) <- nn

train <- read.csv(file="D:\\MO444\\2015s2-mo444-assignment-04\\trat_100.csv", sep=",", header = FALSE, nrows=20000, skip = 25000)

val <- read.csv(file="D:\\MO444\\2015s2-mo444-assignment-04\\trat_100.csv", sep=",", header = FALSE, nrows=20000, skip = 1)

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

# fft_train <- d[1,]
# rm(fft_train)
target <- as.numeric(dim(d)[2])

fft_train <- apply(d, 1, function(x) {
  aux <- x[-target]
  aux <- as.vector(aux)
  aux <- as.numeric(aux)
  test <- fft(aux)
  # extract magnitudes and phases
  magn <- Mod(test) # sqrt(Re(test)*Re(test)+Im(test)*Im(test))
  # plot(test, magn)
  new_row <- as.data.frame(t(magn))
  new_row[,target] <- x[target]
  new_row
})

library(plyr)
fft_train <- ldply(fft_train, data.frame)

# original data
pca <- princomp(fft_train[,-target]) # principal components analysis using correlation matrix
pc.comp <- pca$scores
d <- as.data.frame(fft_train[,target])
colnames(d) <- c("V1")
d <- cbind(d,pc.comp)

fmla <- as.formula(paste("V1 ~ ",paste(colnames(d[,-1]),sep=" ", collapse = " + ")))

library(randomForest)
fit <- randomForest(fmla,data=d)
print(fit) # view results
plot(fit)

# original data
pca <- princomp(val[,-1]) # principal components analysis using correlation matrix
pc.comp <- pca$scores
d <- as.data.frame(val$V1)
colnames(d) <- c("V1")
d <- cbind(d,pc.comp)

t <- as.matrix(d[,-1])
vars <- apply(t, 2, var) #apply in each column
d <- as.data.frame(t[,vars > quantile(vars, cut_off)]) #get columns have more variance than 90%
d$V1 <- val[,1] # add column with activity

fft_val <- apply(d, 1, function(x) {
  aux <- x[-target]
  aux <- as.vector(aux)
  aux <- as.numeric(aux)
  test <- fft(aux)
  # extract magnitudes and phases
  magn <- Mod(test) # sqrt(Re(test)*Re(test)+Im(test)*Im(test))
  # plot(test, magn)
  new_row <- as.data.frame(t(magn))
  new_row[,target] <- x[target]
  new_row
})

fft_val <- ldply(fft_val, data.frame)

# original data
pca <- princomp(fft_val[,-target]) # principal components analysis using correlation matrix
pc.comp <- pca$scores
d <- as.data.frame(fft_val[,target])
colnames(d) <- c("V1")
d <- cbind(d,pc.comp)

val.pred <- predict(fit, d[,-1])
table(observed = val[,1], predicted = val.pred)

library(caret)
u = union(val.pred, d[,1])
t = table(factor(val.pred, u), factor(d[,1], u))
confusionMatrix(t)

confusionMatrix(xtab)
plot(fit, main = "25% dos atributos" )
legend("topright", colnames(fit$err.rate),col=1:4,cex=0.8,fill=1:4)

