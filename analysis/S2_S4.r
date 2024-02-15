##################################################################
############# TuringToM: S2 v S4 (both VA and LLM) ###############

# COMPARES S2'S RATINGS WITH BOTH VA AND LLM PERFORMANCE IN THE S4 ANSWER DISCRIMINATION TURING TEST
# Script to combine S2 with VA, S2 with GPT, then plot both of these, for separate Category 

library(tidyverse)
library(ggpmisc)

# Remove objects from memory and clear the environment
rm(list=ls())

# Read in summary dfs, assuming you kept same file structure as on osf and as advised in `Turing_Main.r`
# These sumamry dfs all made in the preceding scripts
S2_Q_means <- read.csv("../data/S2_Q_means.csv") # made in `S2.r`
S4_vis_VA <- read.csv("../data/S4_vis_VA.csv") # made in `S2_VA.r`
S4_vis_LLM <- read.csv("../data/S4_vis_LLM.csv") # made in `S2_LLM.r`


# --------------- S2 and S4 comparison -------------------

# -------------   First for LLM ---------------------------

# For scatter plot, need each Q and its S2 score and its S4 score
S2_S4_LLM <- merge(S4_vis_LLM, S2_Q_means, by="Q")
# Select only the necessary columns
S2_S4_LLM <- S2_S4_LLM %>% select(Q, Text.x, mean, prop_human, Category.x)
# Rename for a neat chart
names(S2_S4_LLM)[names(S2_S4_LLM) == 'Category.x'] <- 'Category'
names(S2_S4_LLM)[names(S2_S4_LLM) == 'prop_human'] <- 'correct'
# Recode as factors
S2_S4_LLM$Category <- as.factor(S2_S4_LLM$Category)

#-------------- Then for VA -------------------------

S2_S4_VA <- merge(S4_vis_VA, S2_Q_means, by="Q")
# Select only the necessary columns
S2_S4_VA <- S2_S4_VA %>% select(Q, Text.x, mean, prop_human, Category.x)
# Rename
names(S2_S4_VA)[names(S2_S4_VA) == 'Category.x'] <- 'Category'
names(S2_S4_VA)[names(S2_S4_VA) == 'prop_human'] <- 'correct'
# Recode as factors
S2_S4_VA$Category <- as.factor(S2_S4_VA$Category)

# ---------------------- Combined color and black line plots for Fig.4 of paper --------------------

# These are with the eq / coefs in the split-out colors ON the fig 
# And total regression line in black but with coefs for that added later in caption

# LLM - for Fig.4(b)
P1 <- ggplot(S2_S4_LLM, aes(x=mean, y=correct, shape =Category, # aes for the whole plot is for the different Categories to haev their own color and linetype
                        color=Category, linetype=Category)) +
  geom_point(aes(shape=Category, color=Category)) + # and scatterplot by Category
  geom_line(stat="smooth", method="lm", alpha = 0.5, linewidth = 1) +
  stat_poly_eq(use_label(c("R2", "p", "n")), small.r = TRUE, small.p = TRUE, 
               label.y = "bottom", label.x = "left") +  # Adds regression coefs in color, but first remember load library ggpmisc
  geom_line(aes(x=mean, y=correct), stat="smooth", method="lm", # Main total regression line. Overrides aes with its own simpler aes.
            linewidth = 1, color = 'black', inherit.aes = F) +
  xlab('Mean expected success in TT (S2), LLM') +
  ylab('% ppts identified human in TT (S4), LLM') +
  theme_bw() +
  guides(color = guide_legend(override.aes = list(size = 3) ) ) # Makes key symbols bigger

P1  # Then save and export as pdf, landscape, size 3.5 x 4.5 inches

# VA - follows same format, all comments also apply - Fig.4(a)
P2 <- ggplot(S2_S4_VA, aes(x=mean, y=correct, shape =Category,
                           color=Category, linetype=Category)) +
  geom_point(aes(shape=Category, color=Category)) +
  geom_line(stat="smooth", method="lm", alpha = 0.5, linewidth = 1) +
  stat_poly_eq(use_label(c("R2", "p", "n")), small.r = TRUE, small.p = TRUE, 
               label.y = "bottom", label.x = "left", inherit.aes = T) +
  geom_line(aes(x=mean, y=correct), stat="smooth", method="lm", 
            linewidth = 1, color = 'black', inherit.aes = F) +
  xlab('Mean expected success in TT (S2), VA') +
  ylab('% ppts identified human in TT (S4), VA') +
  theme_bw() +
  guides(color = guide_legend(override.aes = list(size = 3) ) )

P2

# Then save and export as pdf, landscape, size 3.5 x 4.5 inches
