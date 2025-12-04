here::i_am("code/models.R"
)

library(rvest)
library(dplyr)
library(tidyr)
library(ggplot2)
library(gtsummary)

# Load Data

df <- read.csv(here::here("data/NBA_2025_per_minute_clean.csv"), sep = ",")

# Filter By Minimum Games
min_games <- as.numeric(Sys.getenv("MIN_GAMES", 0))

df <- df %>% filter(games_played >= min_games)

mod <- glm(
  points ~ age,
  data = df
)

primary_regression_table <- 
  tbl_regression(mod) |>
  add_global_p()

summary(mod)

saveRDS(
  primary_regression_table,
  file = 
    here::here("output/primary_regression_table.rds"))
