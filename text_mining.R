library(dplyr)
library(tm)
library(qdap)
library(RWeka)
library(caTools)
library(SnowballC)

source("data_loader.R")
source("data_cleaner.R")

# Load data
data <- load_data()

# Clean data
data <- clean_data(data)

# split the set
split <- sample.split(data$sentiment, SplitRatio = 0.75)
data.train <- subset(data, split == TRUE)
data.test <- subset(data, split == FALSE)

