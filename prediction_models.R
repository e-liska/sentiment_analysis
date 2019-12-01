get_linear_regression_model <- function(force_new_model = FALSE) {
  model_location <- "./regression_model.rds"
  
  if(!file.exists(model_location) || force_new_model) {
    regression_model <-glm(sentiment ~ ., data.train, family = binomial)
    saveRDS(regression_model, model_location)
    return (regression_model)
  }
  readRDS(model_location) %>% return()
}

get_naive_bays <- function (force_new_model = FALSE) {
  model_location <- "./naive_bayes.rds"
  
  if(!file.exists(model_location) || force_new_model) {
    library(e1071)
    nb_model <- naiveBayes(sentiment ~., data = data.train)
    saveRDS(nb_model, model_location)
  }
  readRDS(model_location) %>% return()
}

get_random_forest_model  <- function(force_new_model = FALSE) {
  library(randomForest)
  model_location <- "./random_forest_model.rds"
  
  if(!file.exists(model_location) || force_new_model) {
    oldNames <- names(data.train)
    newNames <- make.names(oldNames, unique = TRUE)
    names(data.train)<-newNames
    names(data.test) <- newNames
    
    rforest_model <- randomForest(sentiment ~., data = data.train)
    saveRDS(rforest_model, model_location)
  }
  readRDS(model_location) %>% return()
}

get_xgboost_machine_model <- function (force_new_model = FALSE) {
  model_location <- "./xgb_model.rds"
  
  if(!file.exists(model_location) || force_new_model) {
    # TODO
  }
  readRDS(model_location) %>% return()
}