#################################################################
######### TuringToM -- S4 -- Answer discrimination ##############

library(tidyverse)

# Remove objects from memory and clear the environment
rm(list=ls())

# Read in qualtrics download from data folder, assuming you kept same file structure as on osf
S4 <- read.csv("../data/S4_VA.csv") # 343 obs of 1976 vars
# Also read in questions texts from S1+S2 same as ever
TQs <- read.csv("../data/TQs.csv") 

# Get correct rows who did not fail attention checks - 271 obs of 1976 vars
S4 <- S4 %>% filter(Status == "IP Address",
                    Finished == "True",
                    A1 == "This answer belongs to a voice assistant", 
                    A2 == "This one definitely belongs to a human", 
                    A3 == "A human gave this response", 
                    A4 == "Probably a voice assistant gave this answer", 
                    A5 == "A voice assistant's response") # 275 obs of xxx vars

# Pull out columns of questions starting with "T" for Turing test
S4_turing <- S4 %>% select(ResponseId, starts_with("T"), -contains(c('Click', 'Submit', 'Open'))) # 271 of 1291
S4_turing_long <- pivot_longer(data = S4_turing, cols = !ResponseId, names_to = "Q", values_to = "Response") # gives 349590 obs
# Remove rows with no data
S4_turing_long[S4_turing_long==""] <- NA
S4_turing_long <- na.omit(S4_turing_long) # now we have 42547 obs


# ------------- For t-test summaries, used in `S4_barplot_VA.r` ------------------------

S4va <- S4_turing_long %>% select(Q, Response)

# To see how many ppts saw each sub-question (of the 9 combos)  
S4va2 <- S4va %>% group_by(Q, Response) %>% summarise(n=n())

# Get correct and incorrect in same row for each subQ
S4va3 <- S4va2 %>% pivot_wider(names_from = Response, 
                               values_from = n, values_fill = 0)
# Get % correct
S4va3$total <- S4va3$Human+S4va3$VA
S4va3$correct <- S4va3$Human/S4va3$total*100

# And need just the stem to tag each superQ 
S4va3$Qsup <- gsub("\\..*","", S4va3$Q)

# And now for t tests on each Q. So need a function to run it across each row.
# Select columns
S4va4 <- S4va3 %>% select(Qsup, Q, correct) 
# Need an agnostic way of referring to pairing
S4va4 <- S4va4 %>% group_by(Qsup) %>% mutate(pair = row_number(Qsup))

# Now select columns and pivot longer
S4va5 <- S4va4 %>% select(Qsup, correct, pair)
S4va6 <- S4va5 %>% pivot_wider(names_from = pair, values_from = correct)

# Transpose because t.test only wants to work on columns
S4vatran <- as.data.frame(t(S4va6[,-1]))

# Now this df can be run a t test on each row
S4vat <- S4vatran %>% 
  apply(.,2, function(x){re=t.test(x,alternative="two.sided",mu=50); return(re$statistic)})

S4tvap <- S4vatran %>% 
  apply(.,2, function(x){re=t.test(x,alternative="two.sided",mu=50); return(re$p.value)}) %>% round(.,4)

# Now getting this stat back to the Qs
S4va7 <- S4va6
S4va7 <- cbind(S4va7, S4vat, S4tvap)
S4va7 <- S4va7 %>% select(Qsup, ...11, ...12)
# Rename
names(S4va7)[2] <- 't'
names(S4va7)[3] <- 'p'
# This now assumed ready to chart. So save df as csv which gets plotted by the script `S4_barplot_VA.r`
write.csv(S4va7, "../data/S4va7.csv")

# ----------- SUMMARY CSVS FOR LATER VISUSALISATION -----------------
S4_turing_157 <- S4_turing_long # first copy the df in case we still need that
S4_turing_157$Q <- gsub("\\..*","", S4_turing_long$Q) # then remove the . and everything after it in the Q name to collapse the 9 pairwise answers
# Get right answers by question
Qsum <- S4_turing_157 %>% group_by(Q, Response) %>% summarise(n=n())

S4_joined <- merge(S4_turing_157, TQs, by="Q")

# Get total of human guesses for each Q - 157 obs of 3 vars
S4_VA <- S4_joined %>% group_by(Q) %>% summarise(Human = sum(Response=="Human"), VA = sum(Response=="VA")) 
# Add a check column so each sums to 271
S4_VA$check <- S4_VA$Human + S4_VA$VA
# And a proportion column because the totals are way different
S4_VA$prop_human <- S4_VA$Human / S4_VA$check  
S4_VA <- merge(S4_VA, TQs, by="Q") # Get the question text back in - 157 obs of 9 vars
S4_VA <- S4_VA[order(S4_VA$prop_human, decreasing = TRUE),] 

# Save df as csv in the data folder to be used in visualising by the script `S2_S4.r`
write.csv(S4_VA, "../data/S4_vis_VA.csv")
