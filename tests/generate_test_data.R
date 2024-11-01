# Load the raster package
library(raster)
library(sf)

# Define a function to generate a 3-band raster covering the entire UK at 5km x 5km resolution
generate_test_raster <- function() {
  # Define extent, resolution, and other parameters
  extent_uk <- extent(-200000, 700000, 0, 1300000)
  resolution <- 5000
  
  # Create an empty RasterBrick
  ncol <- (extent_uk@xmax - extent_uk@xmin) / resolution
  nrow <- (extent_uk@ymax - extent_uk@ymin) / resolution
  r <- brick(ncol = ncol, nrow = nrow, nl = 3)
  
  # Set the CRS and extent
  crs(r) <- CRS("+init=epsg:27700")
  extent(r) <- extent_uk
  
  # Assign values and write to a stemporary file
  values(r[[1]]) <- rep(1:ncol(r), each = nrow(r))
  values(r[[2]]) <- rep(1:nrow(r), times = ncol(r))
  values(r[[3]]) <- values(r[[1]]) + values(r[[2]]) * 2
  
  # Write to a temporary file on disk
  file <- tempfile(fileext = ".tif")
  writeRaster(r, file, format = "GTiff", overwrite = TRUE)
  
  # Read back from disk to ensure values are accessible
  r <- brick(file)
  
  return(r)
}