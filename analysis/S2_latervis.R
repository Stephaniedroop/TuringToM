################################################################
###### Turing ToM -- S2 -- preparing for publication ###########

# -----README ------------------
# This script takes df of S2 results cleaned and made by `S2.r`, and summarises in a plot

library(tidyverse)

# Remove objects from memory and clear the environment
rm(list=ls())

# Read in data
S2j <- read.csv("../data/S2_joined.csv") # 7380 0f 8 vars. This df was saved in the script called S2.r


# ----- PLOTS ----------------------

# For right side of Fig2 in paper
hist <- ggplot(S2j, aes(x=Response, color=Category, fill=Category)) + 
  geom_histogram(binwidth = 1) +
  facet_grid(Category ~ .) +
  xlab('Response (Likert, 1 (very bad) : 5 (very good))') +
  ylab('Number of ratings, unnormalised for ppts') +
  theme_bw() +
  theme(strip.text.y = element_blank())
hist

# For left side of Fig2 in paper
bar <- ggplot(S2j, aes(x=Category, color=Category, fill=Category)) + geom_bar() +
  theme_bw() + 
  scale_x_discrete(labels=c("factual" = "Factual", "personal, objective" = "Objective",
                            "personal, subjective" = "Subjective")) +
  ylab('Count across all ppts and Qs, S1')
bar

# Then save everything landscape, 3.5, 4.5 inches, pdf to get right font size