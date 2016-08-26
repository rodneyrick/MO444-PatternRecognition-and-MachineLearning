df <- read.csv(file="C:\\Users\\rodney\\Desktop\\unicamp\\311_Service_Requests_from_2010_to_Present.csv", 
                  sep=",", header = TRUE,na.strings=c("", "NA"),)

columns_names <- c("Agency","Agency.Name","Complaint.Type",
                   "Descriptor","City","Location.Type",
                   "Incident.Zip","Incident.Address",
                   "Street.Name","Cross.Street.1","Cross.Street.2",
                   "Intersection.Street.1","Intersection.Street.2",
                   "Address.Type","Borough","Created.Date",
                   "Latitude","Longitude")
df <- df[ , which(names(df) %in% columns_names)]
df <- df[!(is.na(df$Latitude) | df$Latitude==""), ]
df <- df[!(is.na(df$Descriptor) | df$Descriptor==""), ]

t <- function(x,p1,p2){
  if(is.na(x[p1]) | x[p1] == ""){
    x <- x[p2]
  }
  else{
    x <- x[p1]
  }
}

d <- apply(df, 1, function(x){t(x,9,12)})
d <- as.data.frame(d)
df$Street.Name <- d$d

d <- apply(df, 1, function(x){t(x,10,12)})
d <- as.data.frame(d)
df$Cross.Street.1 <- d$d

d <- apply(df, 1, function(x){t(x,11,13)})
d <- as.data.frame(d)
df$Cross.Street.2 <- d$d

df$Intersection.Street.1 <- NULL
df$Intersection.Street.2 <- NULL


days <- c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday")
# extract hour and minute
df <- within(df,{
  posb <- as.POSIXlt(Created.Date,format="%m/%d/%Y %I:%M:%S %p")
  hour <- posb$hour
  minute <- posb$min
  #year <- as.numeric(format(posb, "%Y"))
  month <- as.numeric(format(posb, "%m"))
  day <- as.numeric(format(posb, "%d"))
  dates <- format(posb, "%Y-%m-%d")
  time <- format(posb, "%H:%M")
  weekday <- days[posb$wday+1]
  week_num <- posb$wday+1
  posb <- NULL  # cleanup
})
rm(d)

write.csv(df,
          file="C:\\Users\\rodney\\Desktop\\unicamp\\311_Service_Requests_extract.csv",
          row.names = FALSE)

# rm(df, days, columns_names, t)

days <- c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday")
df <- read.csv(file="D:\\MO444\\final\\311_Service_Requests_extract.csv", 
               sep=",", header = TRUE,na.strings=c("", "NA"))

# extract hour and minute
df <- within(df,{
  posb <- as.POSIXlt(Created.Date,format="%m/%d/%Y %I:%M:%S %p")
  week_num <- posb$wday+1
  posb <- NULL  # cleanup
})

names(df)

newdf <- df[1:3000000,]
write.csv(newdf, file="D:\\MO444\\final\\training.csv", row.names = FALSE)

newdf <- df[3000001:nrow(df),]
write.csv(newdf, file="D:\\MO444\\final\\testing.csv", row.names = FALSE)

d <- as.data.frame(table(newdf$Agency))
d <- d[order(-d$Freq),]
write.csv(d,
          file="D:\\MO444\\final\\Agency.csv",
          row.names = FALSE)

d <- as.data.frame(table(newdf$Complaint.Type))
d <- d[order(-d$Freq),]
write.csv(d,
          file="D:\\MO444\\final\\Complaint-Type.csv",
          row.names = FALSE)

d <- as.data.frame(table(newdf$Descriptor))
d <- d[order(-d$Freq),]
write.csv(d,
          file="D:\\MO444\\final\\Descriptor.csv",
          row.names = FALSE)

d <- as.data.frame(table(newdf$Location.Type))
d <- d[order(-d$Freq),]
write.csv(d,
          file="D:\\MO444\\final\\Location-Type.csv",
          row.names = FALSE)

d <- as.data.frame(table(newdf$City))
d <- d[order(-d$Freq),]
write.csv(d,
          file="D:\\MO444\\final\\City.csv",
          row.names = FALSE)

d <- as.data.frame(table(newdf$Borough))
d <- d[order(-d$Freq),]
write.csv(d,
          file="D:\\MO444\\final\\Borough.csv",
          row.names = FALSE)



df <- read.csv(file="D:\\MO444\\final\\training.csv", 
               sep=",", header = TRUE,na.strings=c("", "NA"))


f <- as.data.frame(table(df$Complaint.Type[1:3000000]))
e <- as.data.frame(table(df$City))


sum(f$Freq[f$Freq<10000])

f <- df[df$City=="STATEN ISLAND",]

e <- as.data.frame(prop.table(table(df$Complaint.Type)))
e$Perc <- e$Freq / sum(e$Freq) * 100


df <- read.csv(file="D:\\MO444\\final\\training.csv", sep=",", header = TRUE,na.strings=c("", "NA"), nrows=20)

d <- as.data.frame(table(df$Complaint.Type))

library(ggplot2)

ggplot(d, aes(x = Var1, y = Freq)) + 
  geom_bar(stat = "identity", color = "black", fill = "grey") +
  labs(title = "Frequency by Complaint Type\n", x = "Complaint Type", y = "Frequency") +
  theme_classic() + theme(axis.text.x=element_text(angle=90, hjust=1)) 


columns_names <- c("Latitude","Longitude","minute","hour","week_num")

pca <- prcomp(df[ , which(names(df) %in% columns_names)]) 

d <- as.data.frame(df$Complaint.Type)
d <- cbind(d, as.data.frame(pca$x))
colnames(d) <- c("Complaint.Type","Latitude","Longitude","minute","hour","week_num")

fmla <- as.formula(paste("Complaint.Type ~ ",paste(colnames(d[,-1]),sep=" ", collapse = " + ")))

training <- d[1:50000,]
val <- d[50001:100000,]

library(rpart)
fit <- rpart(fmla, data=training)
print(fit) # view results
plot(fit)

val.pred <- predict(fit, val[,-1])
table(observed = val[,1], predicted = val.pred)

d <- confusionMatrix(val.pred, val[,1])

library(caret)
u = union(val.pred, val[,1])
t = table(factor(val.pred, u), factor(val[,1], u))
confusionMatrix(t)

d <- confusionMatrix(xtab)
plot(fit, main = "100% dos atributos" )
legend("topright", colnames(fit$err.rate),col=1:4,cex=0.8,fill=1:4)



columns_names <- c("Latitude","Longitude","minute","hour","week_num")
library(caret)
library(moments)


columns_names <- c("Latitude","Longitude","minute","hour","week_num")
pca <- prcomp(df[, which(names(df) %in% columns_names)]) 
columns_names <- c("pca_Latitude","pca_Longitude","pca_minute","pca_hour","pca_week_num")
dd <- pca$x
colnames(dd) <- columns_names
df <- cbind(df,dd)

pca_skewness <- apply(df[,columns_names], 1, skewness)
pca_kurtosis <- apply(df[,columns_names], 1, kurtosis)
pca_avg <- apply(df[,columns_names], 1, mean)
pca_min <- apply(df[,columns_names], 1, min)
pca_max <- apply(df[,columns_names], 1, max)

df$skewness <- pca_skewness
df$kurtosis <- pca_kurtosis
df$avg <- pca_avg
df$minimun <- pca_min
df$maximun <- pca_max

write.csv(df[1:3000000,], file="D:\\MO444\\final\\training.csv", row.names = FALSE)
write.csv(df[3000001:nrow(df),], file="D:\\MO444\\final\\testing.csv", row.names = FALSE)

df <- read.csv(file="D:\\MO444\\final\\training.csv", sep=",", header = TRUE,na.strings=c("", "NA"), nrows = 1)
names(df)
