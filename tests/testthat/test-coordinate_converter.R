# Load the necessary libraries
library(sf)
library(testthat)

# Define test cases for the CoordinateConverter class
test_that("CoordinateConverter converts WGS 84 to EPSG:27700 correctly", {
  source("../../R/CoordinateConverter.R")  # Source the module file
  # Create an instance of CoordinateConverter
  converter <- CoordinateConverter$new()
  
  # Test case 1: Known location (e.g., London in WGS 84)
  lat <- 51.5074
  lon <- -0.1278
  expected_x <- 530029  # Approximate British National Grid coordinates for London
  expected_y <- 180380
  
  # Run the conversion
  result <- converter$to_27700(lat, lon)
  
  # Check that the result is close to the expected values (allowing a tolerance for slight differences)
  expect_equal(result[1], expected_x, tolerance = 1)
  expect_equal(result[2], expected_y, tolerance = 1)
})

test_that("CoordinateConverter converts EPSG:27700 to WGS 84 correctly", {
    source("../../R/CoordinateConverter.R")  # Source the module file
  # Create an instance of CoordinateConverter
  converter <- CoordinateConverter$new()
  
  # Test case 2: Known location in British National Grid (e.g., London)
  x <- 530295  # Approximate x-coordinate for London in EPSG:27700
  y <- 179698  # Approximate y-coordinate for London in EPSG:27700
  expected_lon <- -0.124217  # Expected longitude in WGS 84
  expected_lat <- 51.501209  # Expected latitude in WGS 84
  
  # Run the conversion
  result <- converter$to_latlon(x, y)
  
  # Check that the result is close to the expected values (allowing a tolerance for slight differences)
  expect_equal(result[1], expected_lon, tolerance = 0.0001)
  expect_equal(result[2], expected_lat, tolerance = 0.0001)
})

test_that("CoordinateConverter handles invalid inputs gracefully", {
    source("../../R/CoordinateConverter.R")  # Source the module file
  # Create an instance of CoordinateConverter
  converter <- CoordinateConverter$new()
  
  # Test case 3: Invalid latitude and longitude values for to_27700
  expect_error(converter$to_27700("invalid", "dfadfas"),
               "Latitude must be a numeric value between -90 and 90.", fixed = TRUE)
  
  # Test case 4: Invalid x and y values for to_latlon
  expect_error(converter$to_latlon("invalid_x", "invalid_y"),
               "X-coordinate must be a numeric value within British National Grid range (0 to 700000).", fixed = TRUE)
})

test_that("CoordinateConverter handles out-of-range inputs gracefully", {
  converter <- CoordinateConverter$new()
  
  # Test case for out-of-range latitude in to_27700
  expect_error(
    converter$to_27700(100, 0),  # Latitude > 90
    "Latitude must be a numeric value between -90 and 90.",
    fixed = TRUE
  )
  
  # Test case for out-of-range longitude in to_27700
  expect_error(
    converter$to_27700(0, 200),  # Longitude > 180
    "Longitude must be a numeric value between -180 and 180.",
    fixed = TRUE
  )
  
  # Test case for out-of-range x-coordinate in to_latlon
  expect_error(
    converter$to_latlon(800000, 500000),  # X-coordinate > 700000
    "X-coordinate must be a numeric value within British National Grid range (0 to 700000).",
    fixed = TRUE
  )
  
  # Test case for out-of-range y-coordinate in to_latlon
  expect_error(
    converter$to_latlon(500000, 1400000),  # Y-coordinate > 1300000
    "Y-coordinate must be a numeric value within British National Grid range (0 to 1300000).",
    fixed = TRUE
  )
})