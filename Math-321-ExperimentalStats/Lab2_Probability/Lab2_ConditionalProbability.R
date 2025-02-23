###########################################################
## Author: Fady Youssef
## Date: 12/10/2025
## Topic: Conditional Probability
############################################################
#library(tidyverse)
#library(openintro)
library(ggplot2)
# survey <- acs12 

# ----- 1. Task 1 (Summary Tables) -----
cat("Summary of Race:\n")
print(summary(survey$race))

cat("\nSummary of Gender:\n")
print(summary(survey$gender))

cat("\nSummary of Citizenship:\n")
print(summary(survey$citizen))

cat("\nSummary of Employment:\n")
print(summary(survey$employment))

cat("\nSummary of Education Level:\n")
print(summary(survey$edu))

# ----- 2. Task 2 (Bar Graphs) -----
ggplot(survey, aes(x = employment)) +
  geom_bar(fill = "steelblue") +
  ggtitle("Employment Distribution")

ggplot(survey, aes(x = gender)) +
  geom_bar(fill = "red") +
  ggtitle("Gender Distribution")

ggplot(survey, aes(x = race)) +
  geom_bar(fill = "lightgreen") +
  ggtitle("Race Distribution")

ggplot(survey, aes(x = citizen)) +
  geom_bar(fill = "purple") +
  ggtitle("Citizenship Status Distribution")

ggplot(survey, aes(x = edu)) +
  geom_bar(fill = "orange") +
  ggtitle("Education Level Distribution")

# ----- 3. Task 3 (Probability Tables) -----
cat("\nContingency Table: Gender vs Employment\n")
print(table(survey$gender, survey$employment))

cat("\nProbability Table (Proportions): Gender vs Employment\n")
print(prop.table(table(survey$gender, survey$employment)))

# ----- 4. Task 4 (Employment Probabilities) -----
P_employed <- sum(survey$employment == "employed", na.rm = TRUE) / nrow(survey)
P_unemployed <- sum(survey$employment == "unemployed", na.rm = TRUE) / nrow(survey)

cat("\nProbability of being employed:", P_employed, "\n")
cat("Probability of being unemployed:", P_unemployed, "\n")

# ----- 5. Task 5 (Conditional Probability: P(Woman | Employed)) -----
P_woman_given_employed <- prop.table(table(survey$gender, survey$employment), margin = 2)

cat("\nConditional Probability: P(Woman | Employed)\n")
print(P_woman_given_employed)

# ----- 6. Task 6 (COVID-19 Testing Probability (Bayes' Theorem)) -----
# Given data
N <- 5000  # Total population
P_covid <- 0.038  # Probability of having COVID-19
sensitivity <- 0.74  # True positive rate
specificity <- 0.985  # True negative rate

# Calculate values
covid_cases <- P_covid * N
true_pos <- covid_cases * sensitivity
false_pos <- (N - covid_cases) * (1 - specificity) #(N^c)

# Bayes' Theorem: P(COVID | Positive Test)
P_covid_given_positive <- true_pos / (true_pos + false_pos)

cat("\nProbability of having COVID given a positive test result:", P_covid_given_positive, "\n")