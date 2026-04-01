test_that("search_legal() returns dataframe", {

  expect_silent(q <- search_legal(x = "NE-11-33-29W"))
  expect_s3_class(q, "data.frame")
  expect_named(q, c("legal", "type", "long", "lat"))
  expect_equal(q,
               tibble::tribble(
                 ~legal,           ~type,       ~long,      ~lat,
                 "NE-11-33-29W1",  "Quarter",    -101.4656,  51.81913),
               tolerance = 0.0001
  )

})

test_that ("Messages, warnings, and errors show up", {
  expect_warning(search_legal(x = c("NE-11-33-29W", "SW-20-2-1x")),
                 "One or more of the legal land descriptions could not be")
  expect_warning(search_legal(x = "NE-22-8-1E"),
                 "One or more of the legal land descriptions has an ambiguous")
  expect_error(search_legal(x = 5), "Legal land descriptions must be text.")
  expect_error(search_legal(x = "WW-11-33-29W"),
               "No matches found for the legal land descriptions provided")
})


