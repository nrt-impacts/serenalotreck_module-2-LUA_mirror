# module-2-LUA
Module 2 project for Frontiers in Computational Plant Sciences

## Project Overview
The aim of this project is to estimate Leaf Area Index (LAI) from numerical data already extracted from multispectral and RGB drone imagery.
### Motivation
To make an estimation of LAI that is currently made with slow/labor intensive ground measurements, in order to replace manual labor and facilitate collection of phenotypic information in breeding field trials 
### Approach 
Using numerical data already extracted from drone images (NDVI's, amount of green, etcetera) as features, train a Random Forest model (using azodicr/ML-Pipeline) to predict TLA for the average individual in a plot, then multiply by stand count and divide by plot land area to get LAI

## Repository Overview 
### module2_data
This folder contains the numerical extracted data for our group. We  may want to use data from other groups; in this case they will be added as subdirectories such as: `module2_data/other_data`

