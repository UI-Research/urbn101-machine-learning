library(palmerpenguins)
library(tidyverse)

# drop observations with missing values
penguins_na <- penguins %>%
  filter(complete.cases(.)) %>%
  mutate(body_mass_g_complete = body_mass_g)

# randomly set some body_mass_g to missing
set.seed(20201124)

index <- sample(1:nrow(penguins_na), size = 20)

penguins_na[index, "body_mass_g"] <- NA

# save data
penguins_na %>%
  select(-year) %>%
  write_csv("data/penguins.csv")
