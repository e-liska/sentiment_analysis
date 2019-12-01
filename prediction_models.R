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


