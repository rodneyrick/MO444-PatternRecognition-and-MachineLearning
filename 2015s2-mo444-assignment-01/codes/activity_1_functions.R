
# setwd("D:\\MO444\\2015s2-mo444-assignment-01");
library(sqldf);

load_data <- function(is_all_data=FALSE, limit=2000){
  data = NULL;
  if (is_all_data) {
    data <- read.csv(file="YearPredictionMSD.csv", sep = ",");
  }
  else {
    data <- read.csv.sql("YearPredictionMSD.csv", 
                         sql = paste("select * from file order by random() limit ", limit)); 
  }
  # remove first column, because is a row number
  data <- data[-1];
  return (data);
}


# funciton for selecting the most important variables
get_stars = function(fit,variables_names,variables_influences = -1) {
  p = fit[[1]];
  p = p[-length(p)];
  stars = findInterval(p, c(0, 0.001, 0.01, 0.05, 0.1));
  codes = c("***" , "**","*", ".", " ");
  # codes[stars];
  df1 <- data.frame(variables_names);
  df2 <- data.frame(stars);
  myList <- data.frame(df1, df2);
  if(variables_influences == -1) return(myList)
  else return(myList[which(myList$star < variables_influences), ])
}

# normalize data input
normalize_data <- function(data){
  # normalize data input
  data.scaled <- apply(data,2,function(x){return ((x-min(x))/(max(x)-min(x)))});
  # convert into a data.frame again
  data.scaled <- as.data.frame(data.scaled);
  return (data.scaled);
}


# create a formula automatic
automatic_formula <- function(first_column_name, data){
  xnam <- paste(names(data[-1]), sep="");
  fmla <- as.formula(paste(names(first_column_name)," ~ ", paste(xnam, collapse= "+")));
  return (list(fmla,xnam));
}

# return a Sum Square Error
sse <- function(data, model){
  return (
    1/nrow(data) *
      sum(
        (
          (data[-1] * model$coefficients[-1]) - data[,1]
        )^2
      )
  );
}

# all data
# mydata = read.table("YearPredictionMSD.txt",sep=",", header=FALSE)

# save data as CSV for easy import next
# write.table(mydata, file = "YearPredictionMSD.csv", sep = ",", col.names = NA,na="")

# write.table(mydata, file = "YearPredictionMSD_sample.csv", sep = ",", col.names = NA,na="")
# data.train <- read.csv(file="YearPredictionMSD_sample.csv", sep = ",")