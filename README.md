# Inverting the Turing test to track changing intuitions about artificial minds

This is a series of 4 surveys ('S1':'S4'), each of whose output forms the input of the following one, to run a Turing test.

- Survey 1: Question Generation. The first set of participants generated questions to use in a Turing test.
- Survey 2: Question Rating. The second set of participants rated the quality of the Survey 1 questions for how useful they expected the questions to be in discriminating human from machine.
- Survey 3: Question Answering. A subset of the questions were then posed to a third set of participants, and to LLMs and voice assistants ('VA').
- Survey 4: Answer Discrimination. Their answers were shown to a fourth sample of participants tasked with selecting the human answer, i.e., performing a real Turing test. This was run in two phases: human v VA, and human v LLM.

# Credit

This project was initiated by Neil Bramley and Azzurra Ruggerri. Data for S1, S2 and S4_VA (voice assistants) was collected by Cansu Oranc. Later data, design and analysis by Stephanie Droop under agreement from other authors.

# License

2024 openly licensed via CC BY 4.0 https://creativecommons.org/licenses/by/4.0/

# Packages needed in R

tidyverse, ggpmisc

# Files

## Analysis

- `Turing_Main.r` - top level control script to run the other ones

- `S1.r` - data wrangling script for the question generation phase, S1.
- `S2.r` - main analysis script for the question rating phase, S2.

The preceding two stages are the same for the whole series. Thereafter it splits and we have separate data and analysis for the voice assistant and the LLM conditions.

- `S4_VA.r` - main analysis for voice assistant data.
- `S4_LLM.r` - main analysis for LLM data.

Then, for reporting and visualisations there are miscellaneous other scripts that combine and compare data from those.

- `S2_latervis.r` - takes `S2_joined.csv` produced in `S2.r` and plots a summary of participant ratings for Fig.2 of the paper showing how many questions were factual, objective and subjective, and histogram spreads of how good participants thought the questions would be in a Turing test.
- `S4_barplot_VA.r` - takes `S4_vis_VA.csv` produced in `S4_VA.r` and plots the t-test results for voice assistant data for Fig.3(a)
- `S4_barplot_LLM.r` - takes `S4_vis_LLM.csv` produced in `S4_LLM.r` and plots the t-test results for LLM data for Fig.3(b)
- `S2_S4.r` - plots summary of how each question performed in the answer discrimination phase S4 Turing test against how good people thought each question would be in S2 question rating, for voice assistants and LLMs separately.

## Data

- `S1.csv` download from qualtrics survey for question generation phase.
- `TQs.csv` - question text from S1 whcih was manually cleaned and summarised. It is read in and used by all subsequent scripts.
- `S2.csv` download from qualtrics survey for question rating phase.
- `S4_VA.csv` download from qualtrics survey of answer discrimination Turing test for voice assistants.
- `S4_LLM.csv` download from qualtrics survey of answer discrimination Turing test for LLMs.

The other csvs used in the visualisation scripts are saved by the analysis files.

_For non-code documentation, survey flows and procedures, excel workbooks, etc., see osf repository DOI 10.17605/OSF.IO/43CF5_

(The scripts and raw data from here are also included there)
