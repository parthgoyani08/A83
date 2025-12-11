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
