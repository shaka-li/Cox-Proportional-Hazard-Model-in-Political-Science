# Cox Proportional Hazard Model in Political Science

This repository contains materials for the workshop on survival analysis using the Cox Proportional Hazard Model, with applications in political science research.

## Contents
- `slides.qmd`: Lecture slides for the workshop  
- `handout.pdf`: Material summarizes all the content from the workshop. 
- `Read_Ahead.pdf`: Read-ahead material summarizing required packages. 
- `example.Rmd`: Reproducible R code for participants  
- `example.csv`: Example datasets  

## Preparing the Data
The dataset for this workshop is available in the project’s [GitHub repository](https://github.com/shaka-li/Cox-Proportional-Hazard-Model-in-Political-Science). If the link above does not work, you can also access it directly via the following URL: [https://github.com/shaka-li/Cox-Proportional-Hazard-Model-in-Political-Science](https://github.com/shaka-li/Cox-Proportional-Hazard-Model-in-Political-Science).

After cloning or downloading the repository, open R and run:

~~~r
# Preparing the data for Example 1
new_df <- read.csv("example.csv")

# Preparing the data for Example 2
# install.packages("survival") # uncomment if needed
library(survival)
veteran <- survival::veteran
~~~

[^repo-url]: https://github.com/shaka-li/Cox-Proportional-Hazard-Model-in-Political-Science

## Installing and Loading Packages
During the workshop, we will fit the Cox model, generate counterfactual predictions, and interpret results. Before participating, please make sure the following packages are installed and loaded:

~~~r
# Install packages if not already installed
# install.packages(c("survival", "marginaleffects", "ggplot2", "survminer", "rsample"))

# Load required packages ----
library(survival)        # Core survival modeling (e.g., coxph, survfit)
library(marginaleffects) # Marginal effects / contrasts & visualization
library(ggplot2)         # Grammar-of-graphics plotting
library(survminer)       # Convenient survival plots (e.g., ggsurvplot)
library(rsample)
~~~

## Requirements
- R ≥ 4.3  
- Packages: `survival`, `survminer`, `marginaleffects`, `tidyverse`  

## Authors
- **Shaka Y.J. Li** ([shaka9487@fsu.edu](mailto:shaka9487@fsu.edu))  
  Ph.D. Program in Political Science, Florida State University  

- **David Akindoyin** ([daa24d@fsu.edu](mailto:daa24d@fsu.edu))  
  Ph.D. Program in Political Science, Florida State University


