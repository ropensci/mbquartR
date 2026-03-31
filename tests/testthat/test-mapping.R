
test_that("map_quarter() returns a map", {
  library(mapview)
  q <- map_quarter(x = data.frame("legal" = "SW-6-35-29W1")) |>
    suppressMessages()
  expect_s4_class(q, "mapview")
})

test_that ("Messages, warnings, and errors show up", {
  expect_message(map_quarter(x = c("SW-6-35-29W1", "NW-7-33-29W1")),
               "Polygons for quarter sections are approximate") |>
    suppressMessages()
  expect_error(map_quarter(x = data.frame("Location" =
                                            c("SW-6-35-29W1", "test"))),
               "Data frame must have column 'legal'")
  expect_error(map_quarter(x = "test"),
               "One or more of the legal land descriptions could not be found")
  expect_error(
    map_quarter(x = data.frame("legal" = c("SW-6-35-29W1", "test"))),
    "One or more of the legal land descriptions could not be found.")
  expect_warning(
    map_quarter(x = "PL-R-St. Andrews"),
    "One or more of the legal land descriptions provided are a type of")
  expect_warning(
    map_quarter(x = "NE-2-12-12E"),
    "One or more of the legal land descriptions has an ambiguous") |>
    suppressMessages()

})

