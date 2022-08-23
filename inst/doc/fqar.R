## ----setup, include = FALSE, results = "hide"---------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
library(fqar)
library(ggplot2)
library(dplyr)

## -----------------------------------------------------------------------------
databases <- index_fqa_databases()
head(databases)

## -----------------------------------------------------------------------------
missouri_fqas <- index_fqa_assessments(database_id = 63)
head(missouri_fqas)

## -----------------------------------------------------------------------------
missouri_transects <- index_fqa_transects(database_id = 63)
head(missouri_transects)

## -----------------------------------------------------------------------------
grasshopper <- download_assessment(assessment_id = 25961)

## -----------------------------------------------------------------------------
ambrose <- download_assessment_list(database_id = 63,
                                    site == "Ambrose Farm")

## -----------------------------------------------------------------------------
class(ambrose)
length(ambrose)

## -----------------------------------------------------------------------------
rock_garden <- download_transect(transect_id = 6875)
golden <- download_transect_list(database_id = 63,
                                 site == "Golden Prairie")

## -----------------------------------------------------------------------------
grasshopper_species <- assessment_inventory(grasshopper)
glimpse(grasshopper_species)

## -----------------------------------------------------------------------------
grasshopper_summary <- assessment_glance(grasshopper)
names(grasshopper_summary)

## -----------------------------------------------------------------------------
ambrose_summary <- assessment_list_glance(ambrose)

## ---- eval = FALSE------------------------------------------------------------
#  rock_garden_species <- transect_inventory(rock_garden)
#  rock_garden_summary <- transect_glance(rock_garden)
#  golden_summary <- transect_list_glance(golden)

## -----------------------------------------------------------------------------
rock_garden_phys <- transect_phys(rock_garden)
glimpse(rock_garden_phys)

## ----missouri plot, warning = FALSE-------------------------------------------
ggplot(missouri, aes(x = `Native Species`, 
                     y = `Native Mean C`)) +
  geom_point() +
  geom_smooth() +
  scale_x_continuous(trans = "log10") +
  labs(x = "Native Species (logarithmic scale)",
       y = "Native Mean C") +
  theme_minimal()

