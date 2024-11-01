library(sf)
library(R6)

CoordinateConverter <- R6Class("CoordinateConverter",
  public = list(
    # Method: to_27700
    to_27700 = function(lat, lon) {
      # Check that inputs are numeric and within WGS 84 bounds
      if (!is.numeric(lat) || lat < -90 || lat > 90) {
        stop("Latitude must be a numeric value between -90 and 90.")
      }
      if (!is.numeric(lon) || lon < -180 || lon > 180) {
        stop("Longitude must be a numeric value between -180 and 180.")
      }
      
      # Create an sf point in EPSG:4326
      point <- st_sfc(st_point(c(lon, lat)), crs = 4326)
      point_27700 <- st_transform(point, crs = 27700)
      coords <- st_coordinates(point_27700)
      return(coords)
    },
    
    # Method: to_latlon
    to_latlon = function(x, y) {
      # Check that inputs are numeric and within a realistic range for British National Grid
      if (!is.numeric(x) || x < 0 || x > 700000) {
        stop("X-coordinate must be a numeric value within British National Grid range (0 to 700000).")
      }
      if (!is.numeric(y) || y < 0 || y > 1300000) {
        stop("Y-coordinate must be a numeric value within British National Grid range (0 to 1300000).")
      }
      
      # Create an sf point in EPSG:27700
      point <- st_sfc(st_point(c(x, y)), crs = 27700)
      point_4326 <- st_transform(point, crs = 4326)
      coords <- st_coordinates(point_4326)
      return(coords)
    }
  )
)