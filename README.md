# Inverting the Turing test to track changing intuitions about artificial minds

This is a series of 4 surveys ('S1':'S4'), each of whose output forms the input of the following one, to run a Turing test.

- Survey 1: Question Generation. The first set of participants generated questions to use in a Turing test.
- Survey 2: Question Rating. The second set of participants rated the quality of the Survey 1 questions for how useful they expected the questions to be in discriminating human from machine.
- Survey 3: Question Answering. A subset of the questions were then posed to a third set of participants, and to LLMs and voice assistants ('VA').
- Survey 4: Answer Discrimination. Their answers were shown to a fourth sample of participants tasked with selecting the human answer, i.e., performing a real Turing test. This was run in two phases: human v VA, and human v LLM.

\_Note: to avoid duplication, we have only included here as csvs raw files that are not produced by the analysis scripts in R. In general there are many intermediate summary dataframes generated by R scripts, which are best seen by downloading the `Analysis` folder and running the top level script, `Turing_Main.r` or the relevant sub scripts within that. The exceptions are `S2_Q_means.csv` which is explicitly mentioned in the manuscript as the best way to see the main results of S2, `S4_rationale.csv` which is explicitly mentioned in the manuscript as the best way to see the by-person results of the S4 LLM test, and `c1_c2.csv` which is the reduced set of participant rationales rated by two coders for the individual analyses, and so these are included separately in the `Data` folder.\_

# Credit

This project was initiated by [] and []. Data for S1, S2 and S4*VA (voice assistants) was collected by []. Later data, design and analysis by [] under agreement from other authors. \_Note: put these names back in after review*

# License

2024 openly licensed via CC BY 4.0 https://creativecommons.org/licenses/by/4.0/

# Packages needed in R

tidyverse, ggpmisc

# Files

## Analysis

- `Turing_Main.r` - top level control script to run the other ones

- `S1.r` - data wrangling script for the question generation phase, S1.
- `S2.r` - main analysis script for the question rating phase, S2.

The preceding two stages are the same for the whole series. Thereafter it splits and we have separate data and analysis for the voice assistant and the LLM conditions. There is no script for S3 which just obatined answers to S1's questions from actual humans and AI, as the input for S4's actual Turing test.

- `S4_VA.r` - main analysis for voice assistant Turing test.
- `S4_LLM.r` - main analysis for LLM Turing test.

Then, for reporting and visualisations there are miscellaneous other scripts that combine and compare data from those.

- `S2_latervis.r` - takes `S2_joined.csv` produced in `S2.r` and plots a summary of participant ratings for Fig.2 of the paper showing how many questions were factual, objective and subjective, and histogram spreads of how good participants thought the questions would be in a Turing test.
- `S4_barplot_VA.r` - takes `S4_vis_VA.csv` produced in `S4_VA.r` and plots the t-test results for voice assistant data for Fig.3(a)
- `S4_barplot_LLM.r` - takes `S4_vis_LLM.csv` produced in `S4_LLM.r` and plots the t-test results for LLM data for Fig.3(b)
- `S2_S4.r` - plots summary of how each question performed in the answer discrimination phase S4 Turing test against how good people thought each question would be in S2 question rating, for voice assistants and LLMs separately.
- `S4_LLM_qual.r` - calculates inter-rater reliability for the exploratory by-participant qualitative analyses and produced `c1_c2.csv`, a reduced list of responses where both raters agreed, whose themes are expanded upon in the manuscript.

## Data

_This includes data files used as input by the scripts in the Analysis folder. For other supplementary files like pdfs of the survey flow, or a one-off intermediate summary of S2 data produced by the script `S2.r`, see the `Other` folder._

### S1

- `S1.csv` raw download from qualtrics survey for question generation phase ('S1'). _NOTE: This file contains some questions from another survey which was run at the same time, part of a larger study which is not presented in this paper. Queries like `CVAcreA: Please write one creativity and imagination question to which an adult would give the most satisfying answer` are from that. Please use the R script `S1.R` to extract the parts of the survey relevant for this Turing test._
- `TQs.csv` - question text from S1 which was manually cleaned and summarised in the Excel book `S1_coding.xlsx` (see `Other` section). It is read in and used by all subsequent scripts.

### S2

- `S2.csv` download from qualtrics survey for question rating phase. _NOTE: This file contains some questions from another survey which was run at the same time, part of a larger study which is not presented in this paper. Responses in the lefthand c.80% of the file (`Definitely voice assistant`, `More likely voice assistant`, `Both`, `More likely adult`, `Definitely adult`) that do not correspond to the Likert scale stated in the manuscript for rating whether the question is suitable for the Turing test are from that study so should be ignored for the purposes of this study. Please use the R script `S2.R` to extract responses to only those questions beginning with `T` for the Turing test._

### From S3, used to make the S4 surveys

- `S3_VA.csv` - collated transcriptions of S1's questions asked to the voice assistants and their answers.
- `S3_Human.csv` - collated records of S1's questions asked to the humans and their answers. Answers from participants H1, H4, H7 were used for the answer discrimination phase S4.
- `S3_LLM_bob.csv` - GPT3.5 davinci output from 'bob' prompt (see paper).
- `S3_LLM_kate.csv` - GPT3.5 davinci output from 'kate' prompt (see paper).
- `S3_LLM_rowan.csv` - GPT3.5 davinci output from 'rowan' prompt (see paper).

### S4

- `S4_VA.csv` download from qualtrics survey of answer discrimination Turing test for voice assistants.
- `S4_LLM.csv` download from qualtrics survey of answer discrimination Turing test for LLMs.

#### S4's exploratory by-participant qualitative text analysis

- `tocode1.csv` - file sent to Rater 1 for coding task, along with instruction sheet `InstructionsS4rate.pdf`(see `Other` folder)
- `tocode2.csv` - file sent to Rater 2 for coding task, along with instruction sheet `InstructionsS4rate.pdf`(see `Other` folder)
  (The only difference between `tocode1.csv` and `tocode2.csv` is the order of text responses, which are randomised in case either or both quit the task part way. They are then realigned using the lefthand column indices.)
- `coded1.csv` - coded responses received back from Rater 1.
- `coded2.csv` - coded responses received back from Rater 2.
  Both did finish the task.

## Other

_This includes Other supplementary files like pdfs of the survey flow, a one-off intermediate summary of S2 data produced by the script `S2.r` which is mentioned in the manuscript as the best way to see the results of S2 so is mentioned here separately, etc._

### For question generation phase, S1

`TQs.csv` (in the `Data` folder) is the end result of a manual book:

- `S1_coding.xlsx` - four-tab spreadsheet showing working to collate the Turing test questions produced by each participant in S1 (3 each), of which the two most important tabs are (saved separately as csvs for ease of use):
- `S1_questions_raw.csv` - includes nonsensical answers and duplicates
- `S1_questions_coding.csv` - cleaned questions plus notes of coding as per thematic analysis.

### For question rating phase, S2

- `S2_Q_means.csv` - produced in script `S2.r` from raw data `S2.csv`, included here as it was given explicitly in the manuscript as the best place to see the results of S2, ie. the mean rating (column `mean` of all n=252 participants in S2), for each of the 157 questions that had been generated in S1.

### For answer discrimination phase, S4 ("the Turing test")

- `S4_TuringTest_qualtricssurveyitself_VA.pdf` - pdf of the VA S4 Turing test, showing logic, flow and wording of questions.
- `S4_TuringTest_qualtricssurveyitself_LLM.pdf`- pdf of the LLM S4 Turing test, showing logic, flow and wording of questions.

(Explanation of these files: Downloads from Qualtrics of the Turing test surveys. Questions were randomised and, for each one, one of the nine answer pairs was shown. The response marked (1) is the human and the response marked (2) is the AI, and these were shown in random order. The identifying number was not shown. The survey was set up in Qualtrics then run on Prolific for data collection.)

#### For exploratory analysis for LLM part of S4

- `S4_rationale.csv` - by-participant participants' free text explanation of their own strategy for identifying the human answer, with % correct times they correctly identified the human response in the answer-discrimination phase S4. Also includes chisquare test of whether each participant answered correctly or incorrectly. Produced in script `S4_LLM.r` which will put it in the `Data` folder but put here separately as it is referenced in the manuscript in the `Performance by participant` section.
- `S4_rationale_coded.csv` - paper author's initial brainstormed qualitative categories showing intermediate notes.
- `InstructionsS4rate.pdf` - instructions for coders, showing the refined list of categories.
- `c1_c2.csv` - reduced list of responses and ratings after applying very conservative rule of keeping only what was agreed on by both raters. Generated in script `S4_LLM_qual.r` but saved here for ease of use.
