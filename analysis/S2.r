#################################################################
############ TuringToM -- S2 -- Question rating #################

library(tidyverse)

#----------- README ---------------------
# Script to take the original voice assistant data as downloaded from qualtrics, process and visualise
# Splits out and saves several new csvs for separate analyses, once. - check for commented out sections


rm(list=ls())

# Read in qualtrics download from data folder, assuming you kept same file structure as on osf
S2 <- read.csv("../data/S2.csv") # 298 obs of 957 vars
# Read in cleaned S1 Turing test questions same as used throughout this whole series
TQs <- read.csv("../data/TQs.csv") # 157 obs of 5 vars

# ---------- DATA PROCESSING ----------------------

# Get correct rows who did not fail attention checks
S2 <- S2 %>% filter(A1 == "Definitely voice assistant", 
                    A2 == "Definitely adult", 
                    A3 == "More likely adult", 
                    A4 == "Both", 
                    A5 == "More likely voice assistant") # 246 obs of 957 vars

# Pull out only ID and response data 
S2_turing <- S2 %>% select(ResponseId, starts_with("T")) # 246 obs

# Now we need it long
S2_turing_long <- pivot_longer(data = S2_turing, cols = !ResponseId, 
                               names_to = "Q", values_to = "Response") # 38622 obs 

# Remove rows with no data
S2_turing_long[S2_turing_long==""] <- NA
S2_turing_long <- na.omit(S2_turing_long) # 7380 obs of 3 vars

# Now merge S2_turing_long and TQs
# This gives each ppt's rating, plus the q's coding for the 3 dimensions
S2_joined <- merge(S2_turing_long, TQs, by="Q") # 7380 obs of 7 vars

# Now we want to replace the words with the numbers they had on the scale
S2_joined$Response[S2_joined$Response=="Very bad"] <- 1
S2_joined$Response[S2_joined$Response=="Bad"] <- 2
S2_joined$Response[S2_joined$Response=="Average"] <- 3
S2_joined$Response[S2_joined$Response=="Good"] <- 4
S2_joined$Response[S2_joined$Response=="Very good"] <- 5

# Make it numeric
S2_joined$Response <- as.numeric(S2_joined$Response)

# Save joined as csv for when we need it again
write.csv(S2_joined, "../data/S2_joined.csv")

# Some summary checks
ppl <- S2_joined %>% group_by(Q) %>% summarise(n=n())
min(ppl$n) # 42 
max(ppl$n) # 50
mean(ppl$n) # 47.0 
sd(ppl$n)

# How many questions did people rate?
ppl2 <- S2_joined %>% group_by(ResponseId) %>% summarise(n=n()) # As expected, 30 each

# Summarise ratings
rat <- S2_joined %>% group_by(Q) %>% summarise(mean=mean(Response)) # mean response over respondents
min(rat$mean)
max(rat$mean)
mean(rat$mean)
sd(rat$mean)

# For table of most and least good questions, merge rat and TQs
S2_Q_means <- merge(rat, TQs, by="Q")
write.csv(S2_Q_means, "../data/S2_Q_means.csv") 
