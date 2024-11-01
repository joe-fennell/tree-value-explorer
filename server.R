library(shiny)
library(leaflet)
# Define the server logic
server <- function(input, output, session) {
  observe({
    leafletProxy("mymap") %>% 
      clearTiles() %>%
      addProviderTiles(providers[[input$mapType]])
  })
  
  output$mymap <- renderLeaflet({
    leaflet() %>%
      addProviderTiles(providers$OpenStreetMap) %>%
      setView(lng = -74.006, lat = 40.7128, zoom = 12)
  })
  
  observe({
    if (input$addMarkers) {
      leafletProxy("mymap") %>%
        addMarkers(lng = -74.006, lat = 40.7128, popup = "New York City") %>%
        addMarkers(lng = -73.935242, lat = 40.730610, popup = "Queens") %>%
        addMarkers(lng = -73.989308, lat = 40.741895, popup = "Manhattan")
    } else {
      leafletProxy("mymap") %>%
        clearMarkers()
    }
  })
}
