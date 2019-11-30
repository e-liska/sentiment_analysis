library(readr)
library(dplyr)

library(tm)
library(qdap)
library(RWeka)
library(caTools)
library(SnowballC)

# Get data from https://www.cs.cornell.edu/people/pabo/movie%2Dreview%2Ddata/
cornell_data_source <- "https://www.cs.cornell.edu/people/pabo/movie%2Dreview%2Ddata/rt-polaritydata.tar.gz"
cornell_data_location <- "cornell_data.tar.gz"

# Download
download.file(cornell_data_source,destfile=cornell_data_location)

# Untar
untar(cornell_data_location,list=TRUE) 
untar(cornell_data_location, exdir = "data")

# Load
cornell_data.pos <- read.delim("data/rt-polaritydata/rt-polarity.pos", header = FALSE) %>% 
  mutate(sentiment = TRUE, review = V1) %>% 
  select(review, sentiment)
  
cornell_data.neg <- read.delim("data/rt-polaritydata/rt-polarity.neg", header = FALSE) %>% 
  mutate(sentiment = FALSE, review = V1) %>% 
  select(review, sentiment)

cornell_data<- rbind(cornell_data.pos, cornell_data.neg)


rm(cornell_data.pos, cornell_data.neg)
