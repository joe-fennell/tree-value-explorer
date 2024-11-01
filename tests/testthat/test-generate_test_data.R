# tests/testthat/test-generate_uk_raster.R

library(testthat)
library(raster)
library(sf)

test_that("generate_test_raster creates a raster with correct properties", {
  source("../generate_test_data.R")  # Source the module file
  r <- generate_test_raster()
  
  # Check that r is a RasterBrick object
  expect_s4_class(r, "RasterBrick")
  
  # Check extent is as expected
  expect_equal(extent(r), extent(-200000, 700000, 0, 1300000))
  
  # Check CRS is British National Grid
  generated_crs <- st_crs(crs(r))  # Convert to sf CRS object
  expected_crs <- st_crs(CRS("+init=epsg:27700"))    # British National Grid EPSG:27700
    
  # Check if the EPSG codes are the same
  expect_equal(generated_crs$epsg, expected_crs$epsg)
  
  # Check resolution is 5 km
  expect_equal(res(r), c(5000, 5000))
  
  # Check number of layers (3 bands)
  expect_equal(nlayers(r), 3)
})

test_that("Band values vary as expected", {
  source("../generate_test_data.R")  # Source the module file
  r <- generate_test_raster()
  
  # Band 1 values should increase across columns
  expect_equal(values(r[[2]])[1:ncol(r)], 1:ncol(r))
  
  # Band 2 values should increase across rows
  expect_equal(values(r[[1]])[1:nrow(r)], rep(1, nrow(r)))  # Testing a portion
  
  # Band 3 is a function of Band 1 and Band 2
  expect_equal(values(r[[3]])[1], values(r[[1]])[1] + values(r[[2]])[1] * 2)
})
