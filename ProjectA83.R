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

