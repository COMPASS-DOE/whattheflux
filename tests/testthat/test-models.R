test_that("wtf_fit_models works", {
  # These are very basic tests; we'd probably like to do something better
  x <- wtf_fit_models(cars$speed, cars$dist)
  expect_s3_class(x, "data.frame")

  # Produces warnings, but returns a data frame, for perfect-fit data
  suppressWarnings(
    expect_warning(y <- wtf_fit_models(1:3, 1:3))
  )
  expect_s3_class(y, "data.frame")
  expect_true(is.na(y$r.squared_poly))

  # Nonlinear data should generate a message
  expect_message(wtf_fit_models(Puromycin$conc, Puromycin$rate),
                 regexp = "nonlinear data")
})

test_that("wtf_normalize_time works", {
  # numeric input
  x <- 2:4
  expect_equal(wtf_normalize_time(x, TRUE), x - x[1])
  expect_identical(wtf_normalize_time(x, FALSE), x)
  # POSIXct input
  x <- seq(ymd_hms("2024-02-16 20:15:00"), by = "1 min", length.out = 3)
  expect_equal(wtf_normalize_time(x, TRUE), c(0, 60, 120))
  expect_identical(wtf_normalize_time(x, FALSE), x)
})

test_that("wtf_compute_fluxes works", {
  # Make test data
  plots <- LETTERS[1:2]
  times <- 1:3
  normtimes <- wtf_normalize_time(times, TRUE)
  x <- expand.grid(Plot = plots, time = times, conc = 1)
  ff <- function(a, b) data.frame(x = 1) # dummy fit function

  # Normalize times
  out <- wtf_compute_fluxes(x, "Plot", "time", "conc",
                            fit_function = ff, normalize_time = TRUE)
  expect_s3_class(out, "data.frame")
  expect_identical(out$Plot, plots) # one row per plot
  expect_identical(out$time, rep(mean(times), nrow(out))) # mean of raw times
  expect_identical(out$time_min, rep(min(times), nrow(out))) # min of raw times
  expect_identical(out$time_max, rep(max(times), nrow(out))) # max of raw times

  # Raw times
  out <- wtf_compute_fluxes(x, "Plot", "time", "conc",
                            fit_function = ff, normalize_time = FALSE)
  expect_identical(out$Plot, plots) # one row per plot
  expect_identical(out$time, rep(mean(times), nrow(out))) # mean of raw times
  expect_identical(out$time_min, rep(min(times), nrow(out))) # min of raw times
  expect_identical(out$time_max, rep(max(times), nrow(out))) # max of raw times

  # Passing NULL for the group column should return a single row
  out <- wtf_compute_fluxes(x, NULL, "time", "conc",
                            fit_function = ff, normalize_time = TRUE)
  expect_s3_class(out, "data.frame")
  expect_identical(nrow(out), 1L) # one row
  expect_identical(out$time, rep(mean(times), nrow(out))) # mean of raw times
  expect_identical(out$time_min, rep(min(times), nrow(out))) # min of raw times
  expect_identical(out$time_max, rep(max(times), nrow(out))) # max of raw times
})

test_that("wtf_hm1981 works", {
  withr::local_options(whattheflux.quiet = TRUE)

  # Should return NA for linear-ish data, and numeric value for nonlinear
  expect_identical(wtf_hm1981(cars$speed, cars$dist), NA_real_)
  expect_true(!is.na(wtf_hm1981(Puromycin$conc, Puromycin$rate)))
})
