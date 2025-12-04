# Load required libraries
library(rvest)
library(dplyr)
library(tidyr)
library(ggplot2)

# Load and Filter By Minimum Games

df <- read.csv(here::here("data/NBA_2025_per_minute_clean.csv"), sep = ",")

min_games <- as.numeric(Sys.getenv("MIN_GAMES", 0))

df <- df %>% filter(games_played >= min_games)

df_clean <- df %>%
  # Convert columns to numeric
  mutate(
    `three_point_made` = as.numeric(`three_point_made`),
    `two_point_made` = as.numeric(`two_point_made`),
    free_throws_made = as.numeric(free_throws_made),
    position = as.factor(position)
  ) %>%
  # Filter out rows without a position
  filter(!is.na(position))

# Checking filter 
head(df_clean)

avg_by_pos <- df_clean %>%
  mutate(
    position = trimws(position)  
  ) %>%
  group_by(position) %>%
  summarise(
    avg_3P = mean(`three_point_made`, na.rm = TRUE),
    avg_2P = mean(`two_point_made`, na.rm = TRUE),
    avg_FT = mean(free_throws_made, na.rm = TRUE)
  ) %>%
  pivot_longer(
    cols = starts_with("avg_"),
    names_to = "shot_type",
    values_to = "points_per_36"
  ) %>%
  mutate(
    shot_type = recode(shot_type,
                       avg_3P = "3 Point",
                       avg_2P = "2 Point",
                       avg_FT = "Free Throw")
  )

# Plot
bargraph <- ggplot(avg_by_pos, aes(x = position, y = points_per_36, fill = shot_type)) +
  geom_col(position = "dodge") +
  labs(
    title = "Average Points per 36 Minutes by Position and Shot Type",
    x = "Position",
    y = "Points per 36 Minutes",
    fill = "Shot Type",
    caption = "PG = Point Guard, SG = Shooting Guard, SF = Small Forward, PF = Power Forward, C = Center"
  ) +
  scale_y_continuous(expand = c(0,0)) + 
  theme_light()

saveRDS(
  bargraph,
  file = 
    here::here("output/bargraph.rds"))

bargraph
