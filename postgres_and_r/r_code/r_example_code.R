
###########################################
# dms datathon 2016
# R code snippets
###########################################

#clear all object from memory
rm(list=ls())

#increase memory (if required)
memory.limit(123456)


#location of data
myFolder <- 'H:\\phil\\DataScienceMelbourne\\datathon2016\\seekdata\\Data\\Demo\\'

#read in the jobs data
myFile1 <- 'jobs_all.csv'
myFile1 <- paste(myFolder,myFile1,sep="")
jobs <- read.delim(myFile1,header = TRUE,na.strings = "",stringsAsFactors=FALSE)

nrow(jobs)
#1,439,436

head(jobs)

summary(jobs)


#-----------------------------
# benchmark Kaggle submission
#-----------------------------

#flag the rows with the words in we want
myRows1 <- grep(pattern="barista",x=jobs$title,ignore.case = TRUE)
myRows2 <- grep(pattern="chef",x=jobs$title,ignore.case = TRUE)
myRows <- union(myRows1,myRows2)

#create a prediction
jobs$prediction <- 0
jobs[myRows,'prediction'] <- 1


#train and score rows
trainRows <- which(jobs$hat != -1)
scoreRows <- which(jobs$hat == -1)

#calculate the gini on train rows (these are the ones we know the answers for)
library(caTools)

act <- jobs[trainRows,'hat']
pred <- jobs[trainRows,'prediction']

AUC <- colAUC(pred,act,plotROC=TRUE)[1]
GINI <- 2 * (AUC - 0.5)

#expected gini
#0.265

#now create the submission file
submission <- jobs[scoreRows,c('job_id','prediction')]
colnames(submission) <- c('job_id','HAT')
myOutputFile <- paste(myFolder,"R_barista_prediction.csv",sep="")
write.csv(submission,myOutputFile,row.names = FALSE,quote=FALSE)

#submit to Kaggle and you should get
#0.279 




#A MORE SOPHISTICATED MODEL??
head(jobs)

#Remove fields for now 
jobs$prediction <- NULL
jobs$abstract <- NULL
jobs$title <- NULL
jobs$raw_location <- NULL
jobs$location_id <- NULL


#create a feature of the raw job title
rjt <- data.frame(table(jobs$raw_job_type))
rjt <- rjt[order(rjt$Freq,decreasing=TRUE),]
View(rjt)

#create a binary flag for id the title contains the word 'FULL'
myRows <- grep(pattern="FULL",x=jobs$raw_job_type,ignore.case = TRUE)
jobs$FT <- 0
jobs[myRows,'FT'] <- 1

head(jobs)


#######################
# build a model
#######################

#select the rows where we know the actual value
trainRows <- which(jobs$hat != -1)

#build a linear model
myMod <- lm(hat ~ salary_min+salary_max+FT ,data=jobs[trainRows,] ,na.action = na.omit)

#create the prediction
pred <- predict.lm(myMod,jobs[trainRows,])

#this is the actual
act <- jobs[trainRows,'hat']

#make sure nulls are replaced
act[is.na(act)] <- 0
pred[is.na(pred)] <- 0

#calculate the Gini
AUC <- colAUC(pred,act,plotROC=TRUE)[1]
GINI <- 2 * (AUC - 0.5)

GINI


#create the submission file
scoreRows <- which(jobs$hat == -1)
pred <- predict.lm(myMod,jobs[scoreRows,])
pred[is.na(pred)] <- 0
pred <- round(pred, digits=2)

submission <- data.frame(jobs[scoreRows,'job_id'])
submission$HAT <- pred

colnames(submission) <- c('job_id','HAT')
myOutputFile <- paste(myFolder,"R_salary_benchmark.csv",sep="")
write.csv(submission,myOutputFile,row.names = FALSE,quote=FALSE)

#what does this score?






