pca_func <- function(dataset, target_idx=-1, target="V1") {
  # original data
  pca <- princomp(dataset[,target_idx]) # principal components analysis using correlation matrix
  pc.comp <- pca$scores
  d <- as.data.frame(dataset$V1)
  colnames(d) <- c(target)
  d <- cbind(d,pc.comp)
  d
}

cutt_off_columns <- function(dataset, target_idx=-1, cut_off=0.90) {
  t <- as.matrix(dataset[,-1])
  vars <- apply(t, 2, var) #apply in each column
  d <- as.data.frame(t[,vars > quantile(vars, cut_off)]) #get columns have more variance than 90%
  d$V1 <- dataset[,1] # add column with activity
  d
}


get_formula <- function(dataset, target="V1", target_idx=-1){
  fmla <- as.formula(paste(target, " ~ ",paste(colnames(dataset[,target_idx]),sep=" ", collapse = " + ")))
  fmla
}