# Data Science Melbourne Datathon 2016
# Tutorial on Text Mining in R
# Author: Yuval Marom yuvalmarom@gmail.com
# Date: 23 April 2016.

# A good guide can be found here:
# https://rstudio-pubs-static.s3.amazonaws.com/31867_8236987cf0a8444e962ccd2aec46d9c3.html

# load tm package (text mining)
library(tm)
library(SnowballC) # for stemming   


# Read the data (tab delimited)
jobs_data <- read.delim("C:/Users/ymarom/OneDrive for Business/Work/DSM Datathon Tutorial/Data/jobs_sneak.csv")

# view the full dataset
View(jobs_data)

# we want to text mine the "abstract" column.
# let's first look at some rows
jobs_data[1:10,"abstract"]

# convert the text data into a corpus of documents
docs<-Corpus(DataframeSource(data.frame(jobs_data[,"abstract"])))

show(docs) # confirm we've got the right number of documents
writeLines(as.character(docs[[1]])) # look at specific documents
           
# do some pre-processing

docs<-tm_map(docs, removePunctuation)
docs<-tm_map(docs, removeNumbers)
docs<-tm_map(docs,removeWords,stopwords("english"))
docs<-tm_map(docs,stemDocument)
docs<-tm_map(docs,tolower) # convvert all to lower case
docs<-tm_map(docs,stripWhitespace)
docs <- tm_map(docs, PlainTextDocument) # this is needed for the next step: converting the data to a document-term matrix

writeLines(as.character(docs[[1]])) # look at what the documents look like now after all the pre-processing

# turn the data into a structured dataset
x0<-DocumentTermMatrix(docs) #binary coding
x0<-DocumentTermMatrix(docs, control = list(weighting = weightTfIdf)) #tfidf coding
x0 # see how many docs and how many terms in the matrix
inspect(x0[1:10,100:110])

# funny doc identifiers... Here's a link to how to merge job_ids back in:
# http://stackoverflow.com/questions/19850638/tm-reading-in-data-frame-and-keep-texts-id]]))

# remove sparse terms reduce number of columns
x1<-removeSparseTerms(x0,0.975)
x1
inspect(x1[1:10,100:110])

# convert the data into a matrix object - some of the below operations require this
x<-as.matrix(x1)
x[1:10,100:110]

# check what terms we ended up with, sorted by total weight
freq <- sort(colSums(x), decreasing=TRUE)
head(freq,100)

# join the new columns to the original dataset, for a combined, rich, dataset for analysis and modelling!
my_data<-cbind(jobs_data[,c("salary_type","salary_min","salary_max","raw_job_type")],x)
my_data[1:10,0:10]

# other stuff to try:
# n-grams: common combinations of single terms, such as part_time and full_time 
# LSA (latent semantic analysis): use to reduce dimensionality and find latent meaning
# part-of-speech tagging / parsing (eg nouns, verbs, noun phrases)
