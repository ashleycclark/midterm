# ---------------------------------------------------
# BBall Project Scatterplot Script
# Author: Cassandra Ortiz-Nelsen
# Instructions:
# 1. Open this script in R or RStudio.
# 2. Run all lines sequentially.
# 3. Optional: The scatterplot will be saved as 'scatterplot_output.png' in this folder.
# ---------------------------------------------------

# --- 0. Load required packages ---
library(dplyr)
library(ggplot2)
library(janitor)
library(rvest)

# Load Data

nba_pm_df <- read.csv(here::here("data/NBA_2025_per_minute_clean.csv"), sep = ",")

min_games <- as.numeric(Sys.getenv("MIN_GAMES", 0))

nba_pm_df <- nba_pm_df %>% filter(games_played >= min_games)

# --- 7. Convert numeric/stat columns ---
numeric_cols <- setdiff(names(nba_pm_df), c("player", "team", "position"))
nba_pm_df[numeric_cols] <- lapply(nba_pm_df[numeric_cols], function(x) as.numeric(gsub("%", "", x)))

# --- 8. Handle missing positions ---
nba_pm_df <- nba_pm_df %>%
  mutate(position = ifelse(is.na(position), "Unknown", position))

# --- 9. Create steal-to-foul ratio and top players ---
nba_pm_df <- nba_pm_df %>%
  mutate(steal_foul_ratio = ifelse(personal_fouls > 0, steals / personal_fouls, NA))

top_players <- nba_pm_df %>%
  filter(!is.na(steal_foul_ratio)) %>%
  arrange(desc(steal_foul_ratio)) %>%
  slice_head(n = 10)

top_players_subset <- top_players %>% slice(c(1,3,5))  # For labels on scatterplot

# --- 10. Create scatterplot ---
my_scatterplot <- ggplot(nba_pm_df, aes(x = personal_fouls, y = steal_foul_ratio, color = position)) +
  geom_point(alpha = 0.7, size = 2.5, position = position_jitter(width = 0.2, height = 0)) +
  geom_text(
    data = top_players_subset,
    aes(label = player),
    vjust = -0.8,
    size = 3,
    color = "black"
  ) +
  geom_smooth(aes(group = 1), method = "lm", se = FALSE, color = "red3", linetype = "dashed") +
  scale_color_manual(values = c(
    "G" = "hotpink",
    "F" = "#FFD700",
    "C" = "#1E90FF",
    "Unknown" = "gray50"
  )) +
  labs(
    title = "Steal-to-Foul Ratio (NBA 2025)",
    subtitle = "Higher values indicate high-risk, high-reward defenders",
    x = "Personal Fouls per Game",
    y = "Steals per Game",
    color = "Position"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    legend.position = "bottom",
    panel.grid.major = element_line(color = "gray80"),
    panel.grid.minor = element_line(color = "gray90"),
    plot.margin = margin(t = 20, r = 10, b = 10, l = 10)
  ) +
  coord_cartesian(clip = "off")

# --- 11. Optional: save scatterplot as PNG ---
png("output/scatterplot_output.png", width = 800, height = 600)
print(my_scatterplot)
dev.off()

# --- 12. Saving scatterplot as RDS
saveRDS(my_scatterplot, "output/scatterplot.Rds")