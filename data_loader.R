load_data <- function() {
  library(readr)
  library(dplyr)
  
  
  cornell_data_location <- "data/cornell_data.tar.gz"
  kaggle_data_location <- "data/kaggle_data.zip"
  
  # Cornell data
  if(!file.exists(cornell_data_location)) {
    # Get data from https://www.cs.cornell.edu/people/pabo/movie%2Dreview%2Ddata/
    cornell_data_source <- "https://www.cs.cornell.edu/people/pabo/movie%2Dreview%2Ddata/rt-polaritydata.tar.gz"

    # Download
    download.file(cornell_data_source,destfile=cornell_data_location)
    
    # Untar
    untar(cornell_data_location,list=TRUE) 
    untar(cornell_data_location, exdir = "data")
    
  }
  
  # Load
  cornell_data.pos <- read.delim("data/rt-polaritydata/rt-polarity.pos", header = FALSE) %>% 
    mutate(sentiment = TRUE, review = V1) %>% 
    select(review, sentiment)
    
  cornell_data.neg <- read.delim("data/rt-polaritydata/rt-polarity.neg", header = FALSE) %>% 
    mutate(sentiment = FALSE, review = V1) %>% 
    select(review, sentiment)
  
  # Kaggle data
  # To download data, you need to be logged in on kaggle.com
  
  if(!file.exists(cornell_data_location)) {
    kaggle_data_source <- "https://www.kaggle.com/c/word2vec-nlp-tutorial/download/labeledTrainData.tsv"
    
    # Download
    download.file(kaggle_data_source,destfile=kaggle_data_location)
    
    #Unzip
    unzip(kaggle_data_location,list=TRUE) 
    unzip(kaggle_data_location, exdir = "data")
  }
  
  #Load
  kaggle_data <- read_tsv('data/labeledTrainData.tsv') %>% mutate(sentiment = (sentiment != 0), review, id = NULL)
  
  # Bind 
  data<- rbind(cornell_data.pos, cornell_data.neg, kaggle_data)
  
  return(data) 
}