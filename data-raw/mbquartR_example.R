## code to prepare `mbquartR_example` dataset goes here

mbquartR_example <- cache_load() |>
  dplyr::filter(`Formal Legal Description` %in%
                  c("NE-11-033-29W1", "SW-20-002-01W1", "NW-15-011-19W1",
                    "NE-01-012-12E1", "SW-14-008-02E1", "NE-22-008-01E1",
                    "NW-10-009-01E1", "RL-0022-St. Norbert", "NW-29-004-07W1",
                    "SE-02-005-07W1", "SE-07-005-06W1", "SE-08-034-17E1",
                    "SW-06-035-29W1", "NE-02-012-12E1", "PL-000R-St. Andrews",
                    "NW-07-033-29W1"))

usethis::use_data(mbquartR_example, overwrite = TRUE)
