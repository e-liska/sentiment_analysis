library(dplyr)
library(tm)
library(qdap)
library(RWeka)
library(caTools)
library(SnowballC)

source("data_loader.R")
source("data_cleaner.R")
source("prediction_models.R")

measure_accuracy <- function(results, predictions) {
  # Construct confusion matrix
  table(results, predictions)
  # Accuracy 
  accuracy <-  sum(predictions == results)/length(results)
  accuracy
  return (accuracy)
}

# Load data
data <- load_data()

# Clean data
data <- clean_data(data)

# split the set
split <- sample.split(data$sentiment, SplitRatio = 0.75)
data.train <- subset(data, split == TRUE)
data.test <- subset(data, split == FALSE)

# building models

# logistic regression -  82.7% accuracy
regression_model <- get_linear_regression_model()

# Predict and measure accuracy
pred <- predict(regression_model,weighting = function(x) weightTfIdf(x, normalize =TRUE), data.test, type = "response")
pred <- (pred>=0.5)
measure_accuracy(data.test$sentiment, pred)

# Measure accuracy for training data
train_predictions <- predict(regression_model, data.train, type = "response")
train_predictions <- (data.train$pred>=0.5)
measure_accuracy(data.train$sentiment, train_predictions)




