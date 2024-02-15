#################################################################
########## TuringToM -- S1 -- Question generation ###############

library(tidyverse)


rm(list=ls())

# Read in qualtrics download from data folder, assuming you kept same file structure as on osf
S1 <- read.csv("../data/S1.csv") # 216 obs of 189 variables

# We only need the ones who finished
S1 <-  S1 %>% filter(Finished == "True") # 110 obs of 189 variables

#--------- Survey part ----------------------------------------
# Much of this qualtrics survey was for used for a different study and its analysis 
# has been removed because it is not relevant here.

#--------- Turing part: Pull out the Turing test questions ---------------
# Pull out only ID and response data for TURING part
S1_turing <- S1 %>% select(ResponseId, starts_with("T")) 
# Now we need it long - 330 obs of 3 vars
S1_turing_long <- pivot_longer(S1_turing, cols = 2:4, names_to = "Q", values_to = "Response")

# The questions produced here were then analysed manually to remove nonsensical answers and duplicates.
# See this process in the excel book `S1_coding.xlsx` and two tabs from that, `S1_questions_raw.csv` and `S1_questions_coding.csv`
# The cleaned final list of 157 questions then saved as `TQs.csv` and used as basis for further surveys and analyses.
