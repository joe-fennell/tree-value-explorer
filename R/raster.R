library(R6)
library(terra)

RasterReader <- R6Class("RasterReader",
  public = list(
    # Property to hold the raster object
    raster = NULL,
    # Initialize with file path and open the raster
    initialize = function(file_path) {
      # Load the raster and keep it open
      self$raster <- rast(file_path)
    },
    # Method to get values for all bands at a specific coordinate
    get_values_at_coord = function(x, y) {
      # Check if the point is within the raster extent
      if (!ext(self$raster)@inside(x = x, y = y)) {
        stop("Error: The provided coordinates are out of range.")
      }
      # Extract values for all bands at the specified point
      point <- vect(matrix(c(x, y), ncol = 2), crs = crs(self$raster))
      values <- extract(self$raster, point)
      return(values)
    },
    # Destructor method to release resources
    finalize = function() {
      # Release the raster when the object is deleted
      self$raster <- NULL
    }
  )
)