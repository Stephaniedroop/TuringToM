############################################################################
########## Turing ToM -- S4 -- main wrangling and analysis - LLM ###########
library(tidyverse)

# Main data wrangling and analysis script for S4 Turing test (answer discrimination phase), for the LLM condition
# As in other scripts in this project, the lines to write csv summaries to be used by other scripts have been commented out, so 


# Remove objects from memory and clear the environment
rm(list=ls())

# Read in qualtrics download from data folder, assuming you kept same file structure as on osf
S4 <- read.csv('../data/S4_LLM.csv') # 125 obs of 2071 vars 

# Read in questions from S1+S2, same as ever, this used later in the script
TQs <- read.csv("../data/TQs.csv") 

# Get rows of ppt data of those who did not fail attention checks - 118 obs of 2071
S4 <- S4 %>% filter(Status=="IP Address",
                    Finished=="TRUE",
                    A1 == "This answer belongs to a voice assistant", 
                    A2 == "This one definitely belongs to a human", 
                    A3 == "A human gave this response", 
                    A4 == "Probably a voice assistant gave this answer", 
                    A5 == "A voice assistant's response") # 119 obs of xxx vars

# Remove rationale and keep for later
S4_rationale <- S4 %>% select(ResponseId, Rationale)

# Pull out columns
S4_turing <- S4 %>% select(ResponseId, starts_with("T"), -contains(c('Click', 'Submit', 'Open'))) # 271 of 1291 NO 118 of 1414
S4_turing_long <- pivot_longer(data = S4_turing, cols = !ResponseId, names_to = "Q", values_to = "Response") # gives 349590 obs
# Remove rows with no data
S4_turing_long[S4_turing_long==""] <- NA
S4_turing_long <- na.omit(S4_turing_long) # now we have 18526 obs

S4_turing_long$Q <- as.factor(S4_turing_long$Q)

# To see how many ppts saw each sub-question (of the 9 combos)  
S4_turing_long2 <- S4_turing_long %>% group_by(Q, Response) %>% summarise(n=n())

# ------------ Get in format for t test ------------
# Get correct and incorrect in same row for each subQ
S4_turing3 <- S4_turing_long2 %>% pivot_wider(names_from = Response, 
                                              values_from = n, values_fill = 0)
# Get % correct
S4_turing3$total <- S4_turing3$Human+S4_turing3$VA
S4_turing3$correct <- S4_turing3$Human/S4_turing3$total*100

# And need just the stem to tag each superQ 
S4_turing3$Qsup <- gsub("\\..*","", S4_turing3$Q)

# And now for t tests on each Q. So need a function to run it across each row.
# Select columns
S4_turing4 <- S4_turing3 %>% select(Qsup, Q, correct) 
# Need an agnostic way of referring to pairing
S4_turing4 <- S4_turing4 %>% group_by(Qsup) %>% mutate(pair = row_number(Qsup))

# Now select columns and pivot longer
S4_turing5 <- S4_turing4 %>% select(Qsup, correct, pair)
S4_turing6 <- S4_turing5 %>% pivot_wider(names_from = pair, values_from = correct)

# Transpose because t.test only wants to work on columns
S4_tran <- as.data.frame(t(S4_turing6[,-1]))

# Now this df can be run a t test on each row
S4t <- S4_tran %>% 
  apply(.,2, function(x){re=t.test(x,alternative="two.sided",mu=50); return(re$statistic)})

S4tp <- S4_tran %>% 
  apply(.,2, function(x){re=t.test(x,alternative="two.sided",mu=50); return(re$p.value)}) %>% round(.,4)

# Now getting this stat back to the Qs
S4t7 <- S4_turing6
S4t7 <- cbind(S4t7, S4t, S4tp)
S4t7 <- S4t7 %>% select(Qsup, ...11, ...12)
# Rename
names(S4t7)[2] <- 't'
names(S4t7)[3] <- 'p'
# This now assumed ready to chart. So save df as csv in the data folder
write.csv(S4t7, "../data/S4t7.csv") # This now goes to be plotted in script `S4_barplot_LLM.r` 

#------------------ BY PERSON-------------------

# Also want to know how many each person got right
S4_correct <- S4_turing_long %>% group_by(ResponseId, Response) %>% summarise(n=n()) # Once to check they each answered 157

S4_correct <- S4_correct %>% filter(Response=="Human")
S4_correct$percent <- S4_correct$n/157*100

# sum(S4_correct$n)
# sum(S4_correct$incorrect)

# For chisq test
S4_correct$incorrect <- 157-S4_correct$n
# reorder 
S4_correct <- S4_correct[order(S4_correct$n, decreasing = FALSE),]
S4_correct <- S4_correct[,c(1,4,3,5)]
S4_correct$n <- as.numeric(S4_correct$n)
S4_correct <- ungroup(S4_correct)

# New columns with chisq and p
S4_correct$chisq <- S4_correct %>% select(n, incorrect) %>% 
  apply(.,1, function(x){ re=chisq.test(c(x[1],x[2])); return(re$statistic)})

S4_correct$p <- S4_correct %>% select(n, incorrect) %>% 
  apply(.,1, function(x){ re=chisq.test(c(x[1],x[2])); return(re$p.value)}) %>% round(.,4)


# Merge with rationale and write csv in the data folder to be used in the qualitative analysis and in discussion
S4_ppt <- merge(S4_rationale, S4_correct, by="ResponseId") # 118 obs of 7 vars
write.csv(S4_ppt, "../data/S4_rationale.csv") 

# -------------- Summaries for charts and figures eg. in `S2_S4.r` -------------------

# Collapse all combos of Q1 answers to just Q1
S4_turing_157 <- S4_turing_long # first copy the df
S4_turing_157$Q <- gsub("\\..*","", S4_turing_long$Q) # then remove the . and everything after it in the Q name
# Get right answers by question
Qsum <- S4_turing_157 %>% group_by(Q, Response) %>% summarise(n=n())
# Now merge S4_turing_157 and TQs
# This gives each ppt's rating, plus the q's coding for the 3 dimensions
S4_joined <- merge(S4_turing_157, TQs, by="Q") # 18526 obs of 7 vars

# Want total of human guesses for each Q
S4_Q_summary <- S4_joined %>% group_by(Q) %>% summarise(Human = sum(Response=="Human"), LLM = sum(Response=="VA"))
# # Add a check column 
S4_Q_summary$check <- S4_Q_summary$Human + S4_Q_summary$LLM
# # And a proportion column because the totals are way different
S4_Q_summary$prop_human <- S4_Q_summary$Human / S4_Q_summary$check
S4_Q_summary <- merge(S4_Q_summary, TQs, by="Q")
S4_Q_summary <- S4_Q_summary[order(S4_Q_summary$prop_human, decreasing = TRUE),]

# Write csv for use in the script `S2_S4.r`
write.csv(S4_Q_summary, "../data/S4_vis_LLM.csv") 