# --------------------------------------------
#
# Author: Shaka Y.J. Li and David Akindoyin
# Copyright (c) 
# Email: yl24m@fsu.edi
#
# Date: 2025-11-21
#
# Script Name: Livecoding in workship 
#
# Script Description: 
# Code we will demonstrate in the workshop
#
# Notes: 
# 
#
# --------------------------------------------

# Library packages

library(survival)     
library(marginaleffects) 
library(ggplot2)       
library(survminer)      
library(rsample)       
library(dplyr)  

#####################
# Preparing the data
#####################

# Preparing the data for example 1
new_df <- read.csv("example.csv")

# Preparing the data for example 2 
# install.packages("survival")
library(survival)
veteran <- survival::veteran 

##############################################
# Example 1: Duration in Authoritarian Regime
##############################################

# Fit cox model

model <- coxph(
  Surv(gwf_duration, gwf_fail) ~ gwf_military + wdi_gdpcapcur + wdi_pop,
  data = new_df
)

# Output results

summary(model)

# Counterfactual Prediction -------------------------------------

## Find the max and min for duration time
min_time <- min(new_df$gwf_duration[new_df$gwf_fail == 1], na.rm = TRUE)
max_time <- max(new_df$gwf_duration[new_df$gwf_fail == 1], na.rm = TRUE)

## Simulate a new dataset for counterfactual scenario
nd <- datagrid(
  gwf_military = 0:1, 
  gwf_duration = round(seq(min_time, max_time, length.out = 25)), 
  grid_type = "counterfactual", 
  model = model 
)

## Apply avg_predictions()
p <- avg_predictions(model,
                     type = "survival", 
                     by = c("gwf_duration", "gwf_military"), 
                     vcov = "rsample",
                     newdata = nd) 

tail(p)

## Factoring variable 

library(dplyr)
p <- p |>
  mutate(gwf_military = factor(gwf_military,
                               levels = c(0, 1),
                               labels = c("Non-military", "Military")))

## Create plot for survival probability
ggplot(p, aes(x = gwf_duration, y = estimate,
              color = as.factor(gwf_military),
              fill  = as.factor(gwf_military))) +
  geom_line(linewidth = 1) +  # Step 1: Draw survival lines
  geom_ribbon(aes(ymin = conf.low, ymax = conf.high),
              alpha = 0.2, color = NA) +  # Step 2: Add confidence bands
  labs(
    x = "Duration (Years)",
    y = "Survival Probability",
    color = "",
    fill  = ""
  )  # Step 3: Clean axis labels and legend


# Differences in Predicted Survival Probability -------------------------------------
tmax <- quantile(new_df$gwf_duration, 0.95, na.rm = TRUE) 

m <- comparisons(
  model,
  variables = "gwf_military",  
  newdata = datagrid(gwf_duration = seq(0, tmax, length.out = 100)), 
  type = "survival", 
  vcov = "rsample" 
)

ggplot(m, aes(x = gwf_duration, y = estimate)) +
  geom_ribbon(aes(ymin = conf.low, ymax = conf.high), 
              fill = "grey80", alpha = 0.5) +
  geom_line(size = 1, color = "black") +
  labs(x = "Regime Duration",
       y = "Difference in Survival Probability") +
  theme_minimal(base_size = 13)

#########################################################
# Example 2: Veterans’ Administration Lung Cancer Dataset
#########################################################

# Fit Cox proportional hazards model
model_c <- coxph(Surv(time, status) ~ trt, data = veteran)
summary(model_c)

# Counterfactual Predictions -------------------------------------

library(marginaleffects)

min_time <- min(veteran$time[veteran$trt == 2], na.rm = TRUE)
max_time <- max(veteran$time[veteran$trt == 2], na.rm = TRUE)

nd <- datagrid(
  status = 0:1, 
  time = round(seq(min_time, max_time, length.out = 200)), 
  grid_type = "counterfactual", 
  model = model_c 
)

ap_surv <- avg_predictions(model_c,
                           type = "survival",
                           by = c("time", "trt"),
                           vcov = "rsample",
                           newdata = nd)

tail(ap_surv)

## Plot Counterfactual Predictions

### Factoring treatment variable
### library(dplyr)
ap_surv <- ap_surv |>
  mutate(trt = factor(trt,
                      levels = c(1, 2),
                      labels = c("Standard", "Chemotherapy")))

ggplot(ap_surv, aes(x = time, y = estimate,
                    color = as.factor(trt),
                    fill  = as.factor(trt))) +
  geom_line(linewidth = 1) +  # Step 1: Draw survival lines
  geom_ribbon(aes(ymin = conf.low, ymax = conf.high),
              alpha = 0.2, color = NA) +  # Step 2: Add confidence bands
  labs(
    x = "Duration (days)",
    y = "Survival Probability",
    color = "",
    fill  = ""
  )

# Counterfactual Comparison -------------------------------------

library(marginaleffects)
time_comp <- comparisons(
  model_c,
  variables = "trt",
  newdata = datagrid(time = c(100, 200, 300, 400, 500)),
  type = "survival"
)

time_comp