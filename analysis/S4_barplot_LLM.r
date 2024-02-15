############################################################################
###### Turing ToM -- S4 -- Visualisation of t test results - LLM ###########
# This follows same format as script `S4_barplot_VA.r` except this is for LLM and that is for VA

library(tidyverse)

# README: This script takes summary of t test results for Turing test of humans v LLM, by question, 
# which was generated in `S4_update.r`, and visualises it in horizontal bar plot for Fig.3(b) of paper

# Read in summary df, assuming you kept same file structure as on osf
S4t <- read.csv("../data/S4t7.csv") # 157 obs of 4 vars.  

# Reorder to descending by t value and assign new index
S4t1 <- S4t[order(S4t$t, decreasing = TRUE),]
S4t1 <- S4t1 %>% mutate(index = 1:nrow(S4t1))

# And a new column for the pvalue category
S4t1 <- S4t1 %>% 
  mutate(sig = if_else(S4t1$p<.001,'p<.001***',
                       if_else(S4t1$p<.01, 'p<.01**',
                               if_else(S4t1$p<.05, 'p<.05*', 'p=insig'))))

names(S4t1)[2] <- 'Q'

# Generate horizontal bar plot 
plt <- ggplot(S4t1, aes(x=desc(index), y=t, fill=sig)) +
  geom_bar(stat="identity") +
  coord_flip() +
  ylab("t-value ") +
  theme(panel.grid = element_blank(),
        axis.text.y = element_blank(),
        axis.title.y = element_blank(),
        axis.ticks.y = element_blank(),
        panel.background = element_blank(),
        legend.title = element_blank(),
        legend.position = c(0.85,0.6))
plt

# Then save as pdf landscape 3.5 x 4.5 inches

# Now retrieve question text - BUT IS THIS THEN USED ANYWHERE? MAYBE DELETE?
TQs <- read.csv("../data/TQs.csv")
S4q <- merge(S4t1, TQs, by="Q")
S4q <- S4q[order(S4q$t, decreasing = TRUE),]

write.csv(S4q, '../data/S4qllm.csv')
