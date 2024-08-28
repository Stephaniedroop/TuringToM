######################################################################
######### Turing ToM - IRR calcs for S4 qualitative analysis #########

# Script to collate rater's ratings of the qualitative responses 
# and calculate Cohen's kappa for interrater reliability

# Load libraries
library(tidyverse)
rm(list=ls())

# --------------- Preprocessing ----------------------

# Data needed - read in 
coded1 <- read.csv('../Data/coded1.csv') # file received by email from rater and saved into the Data folder
coded2 <- read.csv('../Data/coded2.csv') # file received by email from rater and saved into the Data folder

# Replace NAs with 0
coded1[is.na(coded1)] <- 0
coded2[is.na(coded2)] <- 0

# Reorder by the column that was randomised, to put the text responses in the same order
# We may not even need them in order, as they get sumamrised into a contingency table. But heyho
coded1 <- coded1[order(coded1$X.1),]
coded2 <- coded2[order(coded2$X.1),]

# Take just what we need
coded1 <- coded1 %>% select(4,5:10)
coded2 <- coded2 %>% select(4,5:10)

# The order is: Formality, Length, Detail, Emotion, Idiosyncrasy, Self
# Replace with letters to be more workable and consistent
cats <- c('a', 'b', 'c', 'd', 'e', 'f')

colnames(coded1) <- c('Response', cats)
colnames(coded2) <- c('Response', cats)

# ------------- IRR - QUICK AND DIRTY check method ------------------

# Rater 1 and Rater 2 correlations for each category
cor(coded1$a,coded2$a) # 0.58
cor(coded1$b,coded2$b) # 0.77
cor(coded1$c,coded2$c) # 0.86
cor(coded1$d,coded2$d) # 0.64
cor(coded1$e,coded2$e) # 0.2 - Rater 1 is more liberal, many Rater2 doesn't share
cor(coded1$f,coded2$f) # 0.78

# Average = .64


# ------------------ IRR - Cohen's Kappa - strict method  ------------------------

# First we define a function that calculates kappa, given a contingency table.
# Then we set up a blank square matrix the size of the number of categories, 
# then, using ONLY RATINGS AGREED ON BY BOTH RATERS (ie a very conservative method)
# calculate cohen's kappa


# Example code from https://www.datanovia.com/en/lessons/cohens-kappa-in-r-for-two-categorical-variables/

# Function to get kappa from a contingency table
get_kappa <- function(matrix) {
  #checkmate::assert_matrix(matrix)
  stopifnot("input must be single matrix" = is.matrix(matrix))
  diags <- diag(matrix)
  N <- sum(matrix)
  row.marginal.props <- rowSums(matrix)/N
  col.marginal.props <- colSums(matrix)/N
  # Compute kappa
  Po <- sum(diags)/N
  Pe <- sum(row.marginal.props*col.marginal.props)
  k <- (Po - Pe)/(1 - Pe)
}


#  6x6 matrix with split points 
# A contingency table with counts of how many ratings each got
# Then spread each point across the categories covered (handles when a response got multiple ratings)

# Set up a blank matrix
matr <- matrix(nrow = length(cats), ncol = length(cats))
colnames(matr) <- cats
rownames(matr) <- cats
# Replace NAs with 0s
matr[is.na(matr)] <- 0

# Loop without asymmetric modification.    
n_exps <- nrow(coded1) # How many explanations: here it is 118. Checked elsewhere they are same length
n_cats <- length(cats)

# Empty 
newdf <- data.frame(matrix(vector(), 0, n_cats+1), stringsAsFactors=F)


# A function to allocate a point across multiple categories for each row to obtain a contingency table
# And then calculate cohen's kappa using the function above (prints out the value before the table).
# (Written for a different project - hence the names 'v' and 'i' - ignore, it doesn't affect how the function works)
# Then it also saves a df of 'strict' overlap; only those responses and responses shared by both raters

allocate_points <- function(vdat2, idat2) {
  for (exp in 1:n_exps)
  {
    # Pull out v and i's whole rows of their separate ratings for the same explanation
    vexp <- vdat2[exp,]
    iexp <- idat2[exp,]
    # Pull out just the ratings without the text response
    vrat <- vexp[2:7]
    irat <- iexp[2:7]
    # Get total in vrat row and irat row. The point for each explanation will be divided by this
    vsum <- sum(vrat)
    isum <- sum(irat)
    point <- 1/(vsum*isum) #
    # Get positions where v and i gave a rating, giving numerical position in vector
    v <- which(vrat!=0) # 2 3 5
    i <- which(irat!=0) # 2 5
    # Now find that place in the matrix and add point to it 
    matr[v, i] <- matr[v, i] + point
    # Set up an empty row
    strict <- rep(NA, n_cats)
    strict <- as.numeric(vrat & irat)
    row <- data.frame(matrix(NA, nrow = 1, ncol = n_cats+1))
    row[1] <- vexp[1]
    row[2:7] <- strict
    #newdf <- rbind(newdf, row)
    # And append the row to the newdf if at least one rating was shared by both raters
    if (sum(strict)>0) {
      #print(irat)
      newdf <-rbind(newdf, row)
    }
  }  
  matr <- round(matr, digits = 1)
  # Get kappa using function
  k <- get_kappa(matr)
  print(k) # This number is inter-rater reliability
  colnames(newdf) <- c('Response', cats)
  print(newdf)
}

# Run this for the pair of coders
c1_c2 <- allocate_points(coded1, coded2) # 0.37 - relatively low

write.csv(c1_c2, '../Data/c1_c2.csv')
