library(shiny)
library(leaflet)

# Define the UI
fluidPage(
  titlePanel("Interactive Leaflet Map in Shiny"),
  sidebarLayout(
    sidebarPanel(
      h4("Map Controls"),
      selectInput("mapType", "Choose Map Type:",
                  choices = c("OpenStreetMap")),
      checkboxInput("addMarkers", "Show Markers", value = TRUE)
    ),
    mainPanel(
      leafletOutput("mymap")
    )
  )
)