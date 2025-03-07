# Load necessary packages
library(tidyverse)
library(openintro)

 head(fastfood)
# Load the data
data(fastfood)

# Subset data for McDonalds and Dairy Queen
mcdonalds <- subset(fastfood, fastfood$restaurant == "Mcdonalds")
dairyqueen <- subset(fastfood, fastfood$restaurant == "Dairy Queen")

## Exercise 1: Histograms of Calories from Fat

# Histogram for McDonalds
ggplot(data = mcdonalds, aes(x = cal_fat)) +
  geom_histogram(binwidth = 50, fill = "blue", color = "black") +
  ggtitle("McDonald's - Calories from Fat") +
  xlab("Calories from Fat") +
  ylab("Frequency")

# Histogram for Dairy Queen
ggplot(data = dairyqueen, aes(x = cal_fat)) +
  geom_histogram(binwidth = 50, fill = "red", color = "black") +
  ggtitle("Dairy Queen - Calories from Fat") +
  xlab("Calories from Fat") +
  ylab("Frequency")

## Exercise 2: Density Histogram and Normal Curve for Dairy Queen

# Calculate mean and standard deviation for Dairy Queen's calories from fat
dqmean <- mean(dairyqueen$cal_fat)
dqsd <- sd(dairyqueen$cal_fat)

# Density histogram with normal curve
ggplot(data=dairyqueen, aes(x=cal_fat)) +
  geom_histogram(binwidth=50, aes(y=..density..), fill="skyblue", color="black")+
  stat_function(fun = dnorm,
                args = list(mean = dqmean, sd = dqsd),
                col = "blue", linewidth = 1) +
  ggtitle("Dairy Queen, calories from fat") +
  xlab("Calories from Fat") +
  ylab("Density")

## Exercise 3: Q-Q Plot for Simulated Normal Data

# Generate simulated normal data
sim_norm <- rnorm(n = nrow(dairyqueen), mean=dqmean, sd=dqsd)

# Q-Q plot for simulated data
qqnorm(sim_norm, main="Q-Q Plot of Simulated Normal Data")
qqline(sim_norm)

# Q-Q plot for Dairy Queen data
qqnorm(dairyqueen$cal_fat,  main="Q-Q Plot of Dairy Queen Calories from Fat")
qqline(dairyqueen$cal_fat)

## Exercise 4: Multiple Q-Q Plots for Simulated Data

# Generate 3 more sets of simulated normal data and create Q-Q plots
par(mfrow=c(2,2)) # Set up a 2x2 plotting grid
qqnorm(dairyqueen$cal_fat, main="Q-Q Plot of Dairy Queen Calories from Fat")
qqline(dairyqueen$cal_fat)

for (i in 1:3) {
  sim_norm <- rnorm(n = nrow(dairyqueen), mean=dqmean, sd=dqsd)
  qqnorm(sim_norm, main=paste("Q-Q Plot of Simulated Normal Data", i))
  qqline(sim_norm)
}
par(mfrow=c(1,1)) # Reset plotting grid

## Exercise 5: Calories Distribution for McDonalds

# Calculate mean and standard deviation for McDonalds' calories
mcmean <- mean(mcdonalds$calories)
mcsd <- sd(mcdonalds$calories)

# Histogram with normal curve
ggplot(data=mcdonalds, aes(x=calories)) +
  geom_histogram(binwidth=50, aes(y=..density..), fill="skyblue", color="black")+
  stat_function(fun = dnorm,
                args = list(mean = mcmean, sd = mcsd),
                col = "blue", linewidth = 1) +
  ggtitle("McDonalds, calories") +
  xlab("Calories") +
  ylab("Density")

# Q-Q plot for McDonalds data
qqnorm(mcdonalds$calories,  main="Q-Q Plot of McDonalds Calories")
qqline(mcdonalds$calories)

## Exercise 6: Normal and Empirical Probabilities

# a) McDonalds sodium > 1000
mc_sodium_mean <- mean(mcdonalds$sodium)
mc_sodium_sd <- sd(mcdonalds$sodium)

theoretical_prob_mc_sodium <- pnorm(q = 1000, mean = mc_sodium_mean, sd = mc_sodium_sd, lower.tail = FALSE)
empirical_prob_mc_sodium <- sum(mcdonalds$sodium > 1000) / length(mcdonalds$sodium)

cat("McDonalds Sodium > 1000:\n")
cat("Theoretical Probability:", theoretical_prob_mc_sodium, "\n")
cat("Empirical Probability:", empirical_prob_mc_sodium, "\n\n")

# b) Dairy Queen protein between 20 and 30
dq_protein_mean <- mean(dairyqueen$protein)
dq_protein_sd <- sd(dairyqueen$protein)

theoretical_prob_dq_protein_lower <- pnorm(q = 20, mean = dq_protein_mean, sd = dq_protein_sd)
theoretical_prob_dq_protein_upper <- pnorm(q = 30, mean = dq_protein_mean, sd = dq_protein_sd)
theoretical_prob_dq_protein_between <- theoretical_prob_dq_protein_upper - theoretical_prob_dq_protein_lower

empirical_prob_dq_protein_between <- sum(dairyqueen$protein > 20 & dairyqueen$protein < 30) / length(dairyqueen$protein)

cat("Dairy Queen Protein between 20 and 30:\n")
cat("Theoretical Probability:", theoretical_prob_dq_protein_between, "\n")
cat("Empirical Probability:", empirical_prob_dq_protein_between, "\n\n")

# c) Dairy Queen cholesterol < 100
dq_cholesterol_mean <- mean(dairyqueen$cholesterol)
dq_cholesterol_sd <- sd(dairyqueen$cholesterol)

theoretical_prob_dq_cholesterol <- pnorm(q = 100, mean = dq_cholesterol_mean, sd = dq_cholesterol_sd)
empirical_prob_dq_cholesterol <- sum(dairyqueen$cholesterol < 100) / length(dairyqueen$cholesterol)

cat("Dairy Queen Cholesterol < 100:\n")
cat("Theoretical Probability:", theoretical_prob_dq_cholesterol, "\n")
cat("Empirical Probability:", empirical_prob_dq_cholesterol, "\n")
