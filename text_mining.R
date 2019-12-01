library(dplyr)
library(tm)
library(qdap)
library(RWeka)
library(caTools)
library(SnowballC)

source("data_loader.R")

# Load data
data <- load_data()

#Clean data

#clean functions
clean_text <- function(text){
  iconv(text, "latin1", "ASCII", sub="") %>% 
    bracketX()
}

create_corpus <- function(text){
  stopwords <- c(tm::stopwords("english"), "movie", "film")
  VectorSource(text) %>% VCorpus() %>%
    tm_map(stripWhitespace) %>%
    tm_map(removePunctuation) %>%
    tm_map(content_transformer(tolower)) %>%
    tm_map(removeWords, stopwords) %>%
    tm_map(stemDocument)
}

#delete duplicates
data<- data[!duplicated(data),]

# clean corpus
corpus<- data$review %>% clean_text() %>% create_corpus()


# term frequency
reviews <- DocumentTermMatrix(
  corpus, control =list( 
    tokenize = function(x) NGramTokenizer(x, Weka_control(min = 1, max = 2))
  )) %>% 
  removeSparseTerms( 0.98) %>% 
  as.matrix()%>%
  as.data.frame()

reviews$sentiment <- (data$sentiment==TRUE)

# split the set
split <- sample.split(reviews$sentiment, SplitRatio = 0.75)
reviews.train <- subset(reviews, split == TRUE)
reviews.test <- subset(reviews, split == FALSE)

