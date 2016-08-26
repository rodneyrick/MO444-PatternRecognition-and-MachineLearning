
# load data
mo444_base <- read.csv(file="C:\\Users\\rodney\\Desktop\\MO444\\2015s2-mo444-assignment-02\\2015s2-mo444-assignment-02.csv", 
                       sep=",")

mo444_base <- read.csv(file="D:\\MO444\\2015s2-mo444-assignment-02\\2015s2-mo444-assignment-02.csv", 
                       sep=",")

# extract hour and minute
mo444_base <- within(mo444_base,{
  posb <- as.POSIXlt(Dates,format="%Y-%m-%d %H:%M:%S")
  hours <- posb$hour
  mins <- posb$min
  years <- as.numeric(format(posb, "%Y"))
  dates <- format(posb, "%Y-%m-%d")
  time <- format(posb, "%H:%M")
  posb <- NULL  # cleanup
})

write.table(mo444_base, file = "D:\\MO444\\2015s2-mo444-assignment-02\\2015s2-mo444-assignment-02-new.csv", 
            sep = ",", 
            col.names=names(mo444_base),
            row.names = FALSE,
            qmethod = "double")

mo444_base <- read.csv(file="D:\\MO444\\2015s2-mo444-assignment-02\\2015s2-mo444-assignment-02-new.csv", 
                       sep=",")

dim(mo444_base)



str(mo444_base)

times <- as.data.frame(table(mo444_base$Category)),
                             mo444_base$Resolution)
                       )

barplot(times$Freq, names.arg = times$Var1, col = times$Var1, 
        main="Distribuição dos dados por categoria",
        las=2, space=1)

axis(1, at = tickMarks, labels = eventTypes, las = 2, tick = FALSE) 

barplot(table(mo444_base$Category), las = 2, names.arg = abbreviate(times$Var1), 
        col = times$Var1,
        main="Distribuição dos dados por categoria")

#rotate 60 degrees, srt=60
text(seq(1.5,end_point,by=2), par("usr")[3]-0.25, 
     srt = 60, adj= 1, xpd = TRUE,
     labels = paste(times$Var1), cex=0.65)

# Add extra space to right of plot area; change clipping to figure
par(mar=c(5.1, 4.1, 4.1, 8.1), xpd=TRUE)

# Add legend to top right, outside plot region
legend("topright", inset=c(-0.3,0), legend=times$Var1, pch=c(1,3), title="Crime", col = times$Var1)

set.seed(1) # just to get the same random numbers
par(xpd=FALSE) # this is usually the default

plot(1:3, rnorm(3), pch = 1, lty = 1, type = "o", ylim=c(-2,2), bty='L')
# this legend gets clipped:
legend(2.8,0,c("group A", "group B"), pch = c(1,2), lty = c(1,2))

# so turn off clipping:
par(xpd=TRUE)
legend(2.8,-1,c("group A", "group B"), pch = c(1,2), lty = c(1,2))

times <- as.data.frame(table(mo444_base$Resolution))

## Make the frequencies numbers (rather than factors)
dat$freqs <- as.numeric(as.character(dat$freqs))
## Find a range of y's that'll leave sufficient space above the tallest bar
ylim <- c(0, 1.1*max(dat$freqs))
## Plot, and store x-coordinates of bars in xx
xx <- barplot(dat$freqs, xaxt = 'n', xlab = '', width = 0.85, ylim = ylim,
              main = "Sample Sizes of Various Fitness Traits", 
              ylab = "Frequency")
## Add text at top of bars
text(x = xx, y = dat$freqs, label = dat$freqs, pos = 3, cex = 0.8, col = "red")
## Add x-axis labels 
axis(1, at=xx, labels=dat$fac, tick=FALSE, las=2, line=-0.5, cex.axis=0.5)

lat.max <- max(mo444_base$Y)
lat.min <- min(mo444_base$Y)
long.max <- max(mo444_base$X)
long.min <- min(mo444_base$X)

lat <- as.data.frame((mo444_base$Y - lat.min) / (lat.max - lat.min))
long <- as.data.frame((mo444_base$X - long.min) / (long.max - long.min))

d <- cbind(as.data.frame(mo444_base$Category),
           lat$`(mo444_base$Y - lat.min)/(lat.max - lat.min)`,
             long$`(mo444_base$X - long.min)/(long.max - long.min)`)

barplot(times$Freq, main="Car Distribution by Gears and VS",
        xlab="Number of Gears", col=c(rownames(times$Var1)),
        legend = rownames(times$Var1)) 

barplot(times$Freq, 
        main="Car Distribution", 
        names.arg=times$Var1, 
        angle = 90,
        cex.names=0.8)


d <- as.data.frame()

d <- cbind(as.data.frame(mo444_base$Category),
                   as.data.frame(mo444_base$Y),
                   as.data.frame(mo444_base$X))

colnames(d) <- c("Category","lat","long")

hist(times$Freq)

library(ggplot2)

ggplot(times, aes(x = times$Freq, y = times$Var1)) + geom_tile(aes(fill = times$Freq)) + scale_fill_gradient(name = 'Quantidade', low = 'white', high = 'red') + labs(x="Hora",y="Dia da Semana") + ggtitle("Frequência dos crimes distribuído pelos dias da semana e horário") + theme(plot.title = element_text(lineheight=.8, face="bold")) 

d3heatmap(times, colors = "Blues", scale = "col",
          dendrogram = "row", k_row = 3)


d3heatmap(times, scale = "column", colors = "Blues")

d3heatmap(times)

m0 <- matrix(NA, 4, 0)
rownames(times) <- times$Var1

times <- as.data.frame(table(mo444_base$DayOfWeek, mo444_base$hours))

m2 <- cbind(as.data.frame(times$Var2),
                 as.data.frame(times$Freq))

times

colnames(m2, do.NULL = FALSE)
colnames(m2) <- c("Hora","Quantidade")
rownames(m2) <- rownames(times$Var1)
m2 <- as.data.frame(m2)

write.table(times, file = "D:\\MO444\\2015s2-mo444-assignment-02\\times.csv", 
            sep = ",", 
            row.names = FALSE)

url <- "http://datasets.flowingdata.com/ppg2008.csv"
nba_players <- read.csv("D:\\MO444\\2015s2-mo444-assignment-02\\times.csv")
d3heatmap(nba_players, scale = "column", Rowv = times$Var1)

?d3heatmap

require(graphics)
kc <- kmeans(s$lat,3)
points(cl$centers, col = 1:5, pch = 8)

library(d3heatmap)
fit <- Mclust(s)
plot(fit) # plot results
summary(fit) 

library(cluster) 
clusplot(s, fit$cluster, color=TRUE, shade=TRUE, labels=2, lines=0)


library(plyr)
library(tm)
stopWords <- stopwords("en")

desc <- as.data.frame(mo444_base$Descript)
colnames(desc) <- c("description")

d <- as.data.frame(apply(desc, 1, function(x) {rm_stopwords(x, tm::stopwords("english"))}))
punct <- '[]\\?!\"\'#$%&(){}+*/:;,._`|~\\[<=>@\\^-]'
desc <- data.frame(lapply(desc, as.character), stringsAsFactors=FALSE)
desc$words <- strsplit(gsub( punct, "", tolower(desc$description)), split=" ")

desc <- desc[1:200000,]

rm(mo444_base, times)

myCorpus <- apply(desc, 1, function(x){Corpus(VectorSource(x$words))})

# http://rstudio-pubs-static.s3.amazonaws.com/82966_c8fee3e3107241678aa6ecebdd831a41.html
# http://r.789695.n4.nabble.com/package-quot-tm-quot-fails-to-remove-quot-the-quot-with-remove-stopwords-td908708.html


t <- tm_map(myCorpus, removeWords, stopWords)

mycorpusp <- tm_map(myCorpus, removeWords, stopwords("english"))

paste(t,collapse = " ")

rm(s)
for (i in 1:length(t)) {
  s <- paste(t[[i]]$content,sep=" ")
}


t[[1]]$content

print(t)

rm(t)




# inspect the first 5 documents (tweets) inspect(myCorpus[1:5]) 
# The code below is used for to make text fit for paper width 
for (i in 1:5) {
  cat(paste("[[", i, "]] ", sep = ""))
  #writeLines(myCorpus[[i]])
  writeLines(as.character(myCorpus[[i]]))
}

library(tm)
params <- list(minDocFreq = 1,
               removeNumbers = TRUE,
               stemming = TRUE,
               stopwords = TRUE,
               weighting = weightTf)

text.corp <- Corpus(VectorSource(strsplit(as.character(desc$description), punct)))
dtm <- DocumentTermMatrix(text.corp, control = params)
dtm.mat <- as.matrix(dtm)

head(dtm.mat)


fmla <- as.formula(mo444_base$Category ~ mo444_base$PdDistrict)

train <- mo444_base[sample(nrow(mo444_base), 5000), ]
test <- mo444_base[sample(nrow(mo444_base), 5000), ]

# http://ww2.coastal.edu/kingw/statistics/R-tutorials/logistic.html
# http://www.statmethods.net/advstats/glm.html

# fit <- glm(fmla,data=mo444_base,family=binomial())
fit <- glm(fmla,data=train,family=binomial())

summary(fit) # display results
confint(fit) # 95% CI for the coefficients
exp(coef(fit)) # exponentiated coefficients
exp(confint(fit)) # 95% CI for exponentiated coefficients
predict(fit, type="response") # predicted values
residuals(fit, type="deviance") # residuals

plot(fit)

library(SnowballC)


stem_word <- wordStem(mo444_base$Descript, language = "porter")
t <- strsplit(mo444_base$Descript)
t <- split( mo444_base , mo444_base$Descript )
rm(foo,bob2)

str(mo444_base)
bob <- data.frame(apply(mo444_base$Descript, as.character))
bob2 <- as.data.frame(as.matrix(mo444_base$Descript),stringsAsFactors=F)
str(bob2)
t <- strsplit(bob2,fixed = TRUE)
foo <- data.frame(strsplit(as.character(mo444_base$Descript),' ',fixed=TRUE))
foo <- strsplit(as.character(mo444_base$Descript),' ',fixed=TRUE)

all_words <- paste(mo444_base$Descript, collapse=" ")
library(tm)
all_words_source <- VectorSource(all_words)

corpus <- Corpus(all_words_source)
corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, stripWhitespace)
corpus <- tm_map(corpus, removeWords, stopwords("english"))
# verify stopwords's english
# stopwords("english")
dtm <- DocumentTermMatrix(corpus)
dtm2 <- as.matrix(dtm)
frequency <- colSums(dtm2)
frequency <- sort(frequency, decreasing=TRUE)
library(wordcloud)
words <- names(frequency)
wordcloud(words[1:100], frequency[1:100])





to.plain <- function(s) {
  
  # 1 character substitutions
  old1 <- "szşàáâãäåçèéêëìíîïğñòóôõöùúûüı"
  new1 <- "szyaaaaaaceeeeiiiidnooooouuuuy"
  s1 <- chartr(old1, new1, s)
  
  # 2 character substitutions
  old2 <- c("o", "ß", "æ", "ø")
  new2 <- c("oe", "ss", "ae", "oe")
  s2 <- s1
  for(i in seq_along(old2)) s2 <- gsub(old2[i], new2[i], s2, fixed = TRUE)
  
  s2
}

s <- "æxs"
to.plain(s)

