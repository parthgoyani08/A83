library(tidyverse)
library(lubridate)
data <- read.csv("WLD_RTFP_country_2023-10-02.csv")

# Quick structure check
str(data)

# Convert date column to Date type (currently character)
data$date <- as.Date(data$date)

# Basic summary of all variables
summary(data)

# Count missing values per column
colSums(is.na(data))

# For correlation/linear model, we need rows with non-missing Close and Inflation
data_clean <- data %>%
  filter(!is.na(Close),
         !is.na(Inflation))

# How many rows remain?
nrow(data_clean)
data_analysis <- data_clean %>%
  filter(date >= as.Date("2000-01-01"),
         date <= as.Date("2020-12-31"))

# Check number of countries and date range used
length(unique(data_analysis$country))
range(data_analysis$date)
data_analysis %>%
  select(Open, High, Low, Close, Inflation) %>%
  summary()

# Country-level averages 
country_summary <- data_analysis %>%
  group_by(country) %>%
  summarise(
    mean_Close     = mean(Close, na.rm = TRUE),
    mean_Inflation = mean(Inflation, na.rm = TRUE),
    sd_Close       = sd(Close, na.rm = TRUE),
    sd_Inflation   = sd(Inflation, na.rm = TRUE),
    n_obs          = n()
  ) %>%
  arrange(desc(mean_Inflation))

head(country_summary)



# Scatterplot of Inflation vs Close (colour by country)
p_scatter <- ggplot(data_analysis,
                    aes(x = Inflation, y = Close, colour = country)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = TRUE, colour = "black") +
  labs(
    title = "Relationship between Inflation and RTFP (Close) across countries",
    x = "Inflation rate (%)",
    y = "RTFP index (Close)"
  ) +
  theme_minimal()

p_scatter

ggsave("plot_scatter_inflation_close.png",
       plot = p_scatter, width = 7, height = 5, dpi = 300)

# Visualisation – supplementary histogram (Inflation)
p_hist <- ggplot(data_analysis, aes(x = Inflation)) +
  geom_histogram(bins = 30, alpha = 0.7) +
  labs(
    title = "Distribution of Inflation Rates in the Analysis Sample",
    x = "Inflation rate (%)",
    y = "Frequency"
  ) +
  theme_minimal()

p_hist

# Save histogram as PNG 
ggsave("plot_hist_inflation.png",
       plot = p_hist, width = 7, height = 5, dpi = 300)

#correlation between Inflation and Close by country
cor_by_country <- data_analysis %>%
  group_by(country) %>%
  summarise(
    cor_infl_close = cor(Inflation, Close, use = "complete.obs")
  ) %>%
  arrange(desc(cor_infl_close))

head(cor_by_country)

# Pearson correlation test between Inflation and Close
cor_test_overall <- cor.test(
  x = data_analysis$Inflation,
  y = data_analysis$Close,
  use = "complete.obs",
  method = "pearson"
)

cor_test_overall
