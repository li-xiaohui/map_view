# to preprocess the BRAT file to RDS
library(readxl)
library(dplyr)
branches <- read_excel('branches.xlsx')
names(branches) <- make.names(names(branches))
str(branches)

