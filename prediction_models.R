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
  
  oldNames <- names(data.train)
  newNames <- make.names(oldNames, unique = TRUE)
  names(data.train)<-newNames
  names(data.test) <- newNames
  
  if(!file.exists(model_location) || force_new_model) {
    rforest_model <- randomForest(sentiment ~., data = data.train)
    saveRDS(rforest_model, model_location)
  }
  readRDS(model_location) %>% return()
}

get_xgboost_machine_model <- function (force_new_model = FALSE) {
  library(xgboost)
  model_location <- "./xgboost.model"
  
  if(!file.exists(model_location) || force_new_model) {
    
    # Find optimal nr of trees with cross validation
    cv <- xgb.cv(data = data.train %>% select(-sentiment) %>% as.matrix(), 
                 label = data.train$sentiment,
                 nrounds = 120,
                 nfold = 12,
                 objective = "binary:logistic",
                 eta = 0.25,
                 max_depth = 5,
                 early_stopping_rounds = 8,
                 verbose = 0    
    )
    nr_trees_min_error <- (cv$evaluation_log %>% summarize(ntrees = which.min(test_error_mean)))$ntrees
    
    xgb_model <- xgboost(data = data.train %>% select(-sentiment) %>% as.matrix(),
                         label = data.train$sentiment,  
                         nrounds = nr_trees_min_error,       
                         objective = "binary:logistic", 
                         eta = 0.3,
                         depth = 5,
                         verbose = 0  
    )
    xgb.save(xgb_model, model_location)
  }
  xgb.load(model_location) %>% return()
}