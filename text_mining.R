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

# Building models. Predict and measure accuracy

# Logistic regression -  83.7% accuracy
regression_model <- get_linear_regression_model()
pred <- predict(regression_model,weighting = function(x) weightTfIdf(x, normalize =TRUE), data.test, type = "response")
pred <- (pred>=0.5)
measure_accuracy(data.test$sentiment, pred)
# Measure accuracy for training data
measure_accuracy(data.train$sentiment, predict(regression_model, data.train, type = "response")>=0.5)

# Naive Bays accuracy 74.7%
measure_accuracy(predict(get_naive_bays(), data.test), data.test$sentiment)

# Random forest  80.9%
measure_accuracy(predict(get_random_forest_model(), data.test), data.test$sentiment)

# Gradient boosting machne
xgb_model <- get_xgboost_machine_model()
(predict(xgb_model, data.test %>% select(-sentiment) %>% as.matrix()) >=0.5) %>% measure_accuracy(results = data.test$sentiment)
# Train data
measure_accuracy(data.train$sentiment, (predict(xgb_model, data.train %>% select(-sentiment) %>% as.matrix()) >=0.5))


predict_sentiment <- function(review_string){
  # term frequency
  review_dtm <- DocumentTermMatrix(
    review_string %>% clean_text() %>% create_corpus(), control =list( 
      dictionary=colnames(reviews)
    )) %>% 
    as.matrix()%>%
    as.data.frame() 
  probability <- predict(xgb_model, review_dtm %>% select(-sentiment) %>% as.matrix())
  return (probability>=0.5)
}