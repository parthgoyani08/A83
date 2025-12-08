#load dataset "WLD_RTFP_country_2023-10-02.csv"
data <- read.csv("D:/A83Project/A83/WLD_RTFP_country_2023-10-02.csv")
head(data)
colnames(data)

#replace null values with zero
data$Inflation[is.na(data$Inflation)] <- 0
head(data, 20)


