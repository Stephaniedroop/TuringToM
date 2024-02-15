#################################################################
################### TuringToM -- main script ####################

# Top level script that runs the other analysis files in order as well as visualisations
# This assumes you have all the scripts in a folder, and another folder in the same directory called 
# data to read the raw data out of and to save csvs into and also read them out of for the visualisations

rm(list=ls())

# Run wrangling and analysis script for Survey 1 ('S1'), the question generating phase
source("S1.r")

# Run wrangling and analysis script for Survey 2 ('S2'), the question rating phase
source("S2.r")

# Run script for visualisation for reporting S2 results, Fig.2 in paper
source("S2_latervis.r")

# There is a survey 3 where we asked the Turing test questions to people and AI. That data is on osf but
# as it was handled manually there is no code to review for it

# Run script for wrangling and analysis for Survey 4 ('S4') for the voice assistants and the LLMs
source("S4_VA.r")
source("S4_LLM.r")

# Run script for visualisation for reporting S4 results, Fig.3 in the paper
source("S4_barplot_VA.r")
source("S4_barplot_LLM.r")

# Run script for visualisation for reporting S4 vs S2 results, Fig.4 in the paper
source("S2_S4.r")