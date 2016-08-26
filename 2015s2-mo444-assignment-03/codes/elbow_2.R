train <- read.csv(file="D:\\MO444\\2015s2-mo444-assignment-03\\train_original.csv", sep=",",header = FALSE)
val <- read.csv(file="D:\\MO444\\2015s2-mo444-assignment-03\\val_original.csv", sep=",",header = FALSE)

d <- lapply(c(seq(4878, 4883, by=1)), function (x) {
  tim <- proc.time()
  km <- kmeans(train[-1],x)
  print(paste(x, " -->", proc.time() - tim))
  km
})

s <- lapply(d, function(x){ 
  size <- as.data.frame(length(x$size))
  totss <- as.data.frame(as.numeric(x$totss))
  tot.withinss <- as.data.frame(x$tot.withinss)
  betweenss <- as.data.frame(x$betweenss)
  # centers <- as.data.frame(x$centers)
  iter <- as.data.frame(x$iter)
  tt <- cbind(size,totss,tot.withinss,betweenss, iter)
  tt
})

# unique(sort(c(seq(1000, 3000, by=500),seq(2000, 3000, by=100))))
# c(seq(2000, 3000, by=500))

# library(plyr)
ss <- ldply(s, data.frame)

write.table(ss, file = "D:\\MO444\\2015s2-mo444-assignment-03\\pca_original.csv", 
            sep = ",", 
            col.names=names(ss),
            row.names = FALSE)

# 2898 original
# 4880 increased

results <- read.csv(file="D:\\MO444\\2015s2-mo444-assignment-03\\original.csv", sep=",",header = TRUE)
plot(results$length.x.size.,log(results$x.tot.withinss))
lines(results$length.x.size.,log(results$x.tot.withinss), type="l")

results <- read.csv(file="D:\\MO444\\2015s2-mo444-assignment-03\\increased.csv", sep=",",header = TRUE)
plot(results$length.x.size.,results$x.tot.withinss)
plot(results$length.x.size.,results$x.betweenss)
lines(results$length.x.size.,results$x.betweenss, type="l",col="red")
lines(results$length.x.size.,results$x.tot.withinss, type="l",col="black")

# 2 axis
plot(results$length.x.size.,results$x.betweenss.,type="l",col="red")
par(new=TRUE)
plot(results$length.x.size.,results$x.tot.withinss,type="l",col="blue")
axis(4)
mtext("y2",side=4,line=3)
legend("topleft",col=c("red","blue"),lty=1,legend=c("y1","y2"))

train <- read.csv(file="D:\\MO444\\2015s2-mo444-assignment-03\\train_increased.csv", 
                  sep=",",header = FALSE)
# original data
pca <- princomp(train[-1]) # principal components analysis using correlation matrix
pc.comp <- pca$scores
pc.comp1 <- -1*pc.comp[,1] # principal component 1 scores (negated for convenience)
pc.comp2 <- -1*pc.comp[,2] # principal component 2 scores (negated for convenience)

X <- cbind(pc.comp1, pc.comp2)

d <- lapply(c(seq(1000, 1000, by=100)), function (x) {
  z <- Sys.time()
  km <- kmeans(X,x)
  print(paste(x, " -->", Sys.time() - z))
  km$time <- Sys.time() - z
})

s <- lapply(d, function(x){ 
  size <- as.data.frame(length(x$size))
  totss <- as.data.frame(as.numeric(x$totss))
  tot.withinss <- as.data.frame(x$tot.withinss)
  betweenss <- as.data.frame(x$betweenss)
  time <- as.data.frame(x$time)
  # centers <- as.data.frame(x$centers)
  iter <- as.data.frame(x$iter)
  tt <- cbind(size,totss,tot.withinss,betweenss, iter, time)
  tt
})

# unique(sort(c(seq(1000, 3000, by=500),seq(2000, 3000, by=100))))
# c(seq(2000, 3000, by=500))

# library(plyr)
ss <- ldply(s, data.frame)

write.table(ss, file = "D:\\MO444\\2015s2-mo444-assignment-03\\pca_increased.csv", 
            sep = ",", 
            col.names=names(ss),
            row.names = FALSE)


results <- read.csv(file="D:\\MO444\\2015s2-mo444-assignment-03\\pca_original.csv", sep=",",header = TRUE)
plot(results$x.tot.withinss, results$length.x.size., 
     ylab="Número de Centróides", 
     xlab="Total das soma dos quadrados dos centróides",
     main="Total da soma dos quadrados x Número de centróides",
     type="l",col="blue")
# plot(results$length.x.size.,results$as.numeric.x.totss.)
# lines(results$length.x.size.,results$as.numeric.x.totss., type="l",col="red")
# lines(results$length.x.size.,results$x.tot.withinss, type="l",col="black")
abline(h=2880, col = "red")

legend("bottomleft",
       c("Total da Soma dos Quadrados","Limiar de Elbow Rule"), # puts text in the legend
       lty=c(1,1), # gives the legend appropriate symbols (lines)
       lwd=c(2.5,2.5),col=c("blue","red")) # gives the legend lines the correct color and width

results <- read.csv(file="D:\\MO444\\2015s2-mo444-assignment-03\\original.csv", sep=",",header = TRUE)
plot(results$length.x.size., results$x.tot.withinss, 
     ylab="Número de Centróides", 
     xlab="Total das soma dos quadrados dos centróides",
     main="Total da soma dos quadrados x Número de centróides",
     type="l",col="blue")
abline(v=2880, col = "red")


km <- kmeans(X,2300)
plot(pc.comp1, pc.comp2,col=km$cluster,
     main = "2300 Clusters nas componentes do PCA nos dados originais", 
     xlab = "Componente 1", ylab = "Componente 2")
points(km$centers, pch=16)

rm(pc.comp,pc.comp1,pc.comp2,train,pca)

library(cluster)
km <- kmeans(X,2300)
dissE <- log(X)
sk <- silhouette(km$cl,dissE)
plot(sk)

## but kmeans is rather equivalent to work with  {D_ij}^2,
## hence this better corresponds:
dE2 <- dissE^2
sk2 <- silhouette(km$cl, dE2)
plot(sk2)


write.table(X, file = "D:\\MO444\\2015s2-mo444-assignment-03\\pca_X.csv", 
            sep = ",",
            col.names = FALSE,
            row.names = FALSE)
X <- read.csv(file="D:\\MO444\\2015s2-mo444-assignment-03\\pca_X.csv", sep=",",header = FALSE)
X <- X[2:nrow(X),]





