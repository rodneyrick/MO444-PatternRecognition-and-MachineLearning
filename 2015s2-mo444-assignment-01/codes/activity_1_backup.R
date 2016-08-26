
setwd("D:\\MO444\\2015s2-mo444-assignment-01")
source("activity_1_functions.R")

# load data
data <- load_data(is_all_data=FALSE, limit=50000)

# training
train <- normalize_data(data[1:10000,])
# test
test <- normalize_data(data[10000:nrow(data),])

# create a formula automatic
xnam <- paste(names(train[-1]), sep="")
fmla <- as.formula(paste(names(train[1])," ~ ", paste(xnam, collapse= "+")))

# execute Linear Regression
model_1 = lm(fmla, data=train)

# check results
summary(model_1)

xnam <- paste(names(train[-1]), sep="")

fmla <- as.formula(
  paste0("V1 ~ ",
         paste(sprintf(" %+.2f * %s ", 
                       coef(summary(model_1))[-1,1],  
                       names(coefficients(model_1)[-1])), 
               collapse="")
  )
)

fmla <- gsub("  ","",fmla)

# execute Linear Regression
model_2 = lm(formula=V1 ~ V2, data=train)

model_1.sse <- sse(train,model_1)
model_2.sse <- sse(test,model_2)

ggplot(train, aes(x=V2 + V3 + V4 + V5 + V6 + V7 + V8 + V9 + V10 + V11 + V12 + V13 + V14 + V15 + V16 + V17 + V18 + V19 + V20 + V21 + V22 + V23 + V24 + V25 + V26 + V27 + V28 + V29 + V30 + V31 + V32 + V33 + V34 + V35 + V36 + V37 + V38 + V39 + V40 + V41 + V42 + V43 + V44 + V45 + V46 + V47 + V48 + V49 + V50 + V51 + V52 + V53 + V54 + V55 + V56 + V57 + V58 + V59 + V60 + V61 + V62 + V63 + V64 + V65 + V66 + V67 + V68 + V69 + V70 + V71 + V72 + V73 + V74 + V75 + V76 + V77 + V78 + V79 + V80 + V81 + V82 + V83 + V84 + V85 + V86 + V87 + V88 + V89 + V90 + V91, y=V1)) +
  geom_point(aes(color = V1)) +
  geom_smooth(method=glm,span = 0.5) +
  geom_jitter(alpha = 0.1)
  


# remove variables not necessary
best_variables <- get_stars(model_1, xnam, 1)

# create a formula automatic
xnam <- paste(best_variables$variables_names, sep="")
fmla <- as.formula(paste(names(train[1])," ~ ", paste(xnam, collapse= "+")))

# execute Linear Regression
model_2 = lm(fmla, data=train)

test.predict_1 <- predict(model_1, newdata=test,interval="predict")
plot(test.predict_1)
abline(model_1,col="blue")

test.predict_2 <- predict(model_2, newdata=test,interval="predict")
plot(test.predict_2)
abline(model_2,col="blue")

train.sse_1 <- sse(train, model_1)
test.sse_1 <- sse(test, model_1)

train.sse_2 <- sse(train, model_2)
test.sse_2 <- sse(test, model_2)

# diagnostic plots
layout(matrix(c(1,2,3,4),2,2)) # optional 4 graphs/page
plot(model_1)
plot(model_2)

anova(model_1, model_2)

set.seed(955)
# Make some noisily increasing data
dat <- data.frame(cond = rep(c("A", "B"), each=10),
                  xvar = 1:20 + rnorm(20,sd=3),
                  yvar = 1:20 + rnorm(20,sd=3))
summary(dat)
library(ggplot2)

ggplot(dat, aes(x=xvar, y=yvar)) +
  geom_point(shape=1)      # Use hollow circles

ggplot(dat, aes(x=xvar, y=yvar)) +
  geom_point(shape=1) +    # Use hollow circles
  geom_smooth(method=lm)   # Add linear regression line 
#  (by default includes 95% confidence region)

ggplot(dat, aes(x=xvar, y=yvar)) +
  geom_point(shape=1) +    # Use hollow circles
  geom_smooth(method=lm,   # Add linear regression line
              se=FALSE)    # Don't add shaded confidence region


ggplot(dat, aes(x=xvar, y=yvar)) +
  geom_point(shape=1) +    # Use hollow circles
  geom_smooth()            # Add a loess smoothed fit curve with confidence region
#> geom_smooth: method="auto" and size of largest group is <1000, so using loess. Use 'method = x' to change the smoothing method.
