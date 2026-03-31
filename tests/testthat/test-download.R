test_that("url_ok()", {
  skip("httpstat site is down")
  skip_if_offline()
  expect_true(url_ok("httpstat.us/200"))
  expect_false(url_ok("httpstat.us/202"))
  expect_false(url_ok("httpstat.us/404"))
})

test_that("cache_dir()", {
  expect_silent(d <- cache_dir())
  expect_equal(d, tools::R_user_dir("mbquartR"))

  o <- options("mbquartR_cache_dir" = "/home/mbquartR")
  expect_silent(d <- cache_dir())
  expect_equal(d, "/home/mbquartR")
  options(o)
})

test_that("cache_file()", {
  expect_silent(f <- cache_file())
  expect_equal(basename(f), "mb_quarters.csv")
})

test_that ("cache_check()", {
  unlink(cache_dir(), recursive = TRUE)
  expect_false(dir.exists(cache_dir()))
  expect_error(cache_check(ask = "yes"), "Argument `ask` must be TRUE or FALSE")
  expect_silent(q <- cache_check(ask = FALSE))
  expect_true(dir.exists(cache_dir()))
})

test_that("cache_dl()", {
  skip_if_offline()
  unlink(cache_file())

  expect_error(cache_load(), "Data does not exist, please download with",
               fixed = TRUE)

  # Download works
  expect_false(file.exists(cache_file()))
  expect_message(cache_dl(quiet = TRUE), "You have downloaded") |>
    suppressMessages()
  expect_true(file.exists(cache_file()))

  # File contents correct
  expect_gt(file.info(cache_file())$size, 100000)

  expected_content <- paste0(
    "FID,Informal Legal Description,Formal Legal Description,Type,Quarter,",
    "SECTION,TOWNSHIP,RANGE,LOT NO,MERIDIAN,PARISH NAME,RANGEADD,x,y")
  actual_content <- readLines(cache_file(), n = 1)
  expect_equal(actual_content, expected_content)
})


test_that ("quarters_dl() - Messages, warnings, and errors show up", {
  unlink(cache_dir(), recursive = TRUE)

  expect_error(quarters_dl(ask = "yes"), "Argument `ask` must be TRUE or FALSE")
  expect_message(quarters_dl(ask = FALSE, quiet = TRUE),
                 "You have downloaded") |>
    suppressMessages()
  expect_message(quarters_dl(), "File exists, skipping download")
})
