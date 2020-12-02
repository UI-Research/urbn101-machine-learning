library(tidymodels)

penguins <- read_csv(here::here("data", "penguins.csv"))

penguins_na <- penguins %>%
  filter(is.na(body_mass_g))

penguins <- penguins %>%
  filter(!is.na(body_mass_g))

set.seed(20201124)

penguins_split <- initial_split(data = penguins, prop = 0.75)

penguins_train <- training(x = penguins_split)

knn_mod <-
  nearest_neighbor(neighbors = tune()) %>% 
  set_engine(engine = "kknn") %>% 
  set_mode(mode = "regression")

penguins_rec <- 
  recipe(~body_mass_g ~ bill_length_mm + bill_depth_mm + flipper_length_mm, data = penguins_train) %>%
  step_normalize(bill_length_mm, bill_depth_mm, flipper_length_mm)

penguins_wf <- 
  workflow() %>%
  add_model(knn_mod) %>%
  add_recipe(penguins_rec)

folds <- vfold_cv(data = penguins_train, v = 10)

knn_grid <- tibble(neighbors = 1:100)

knn_res <- penguins_wf %>%
  tune_grid(resamples = folds, 
            grid = knn_grid,
            control = control_grid(save_pred = TRUE), 
            metrics = metric_set(rmse))

knn_res %>%
  select_best(metric = "rmse")
