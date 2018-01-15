
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(leaflet)

shinyUI(fluidPage(

  fluidRow(
    leafletMap(
      "map", "100%", 400,
      initialTileLayer = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
      initialTileLayerAttribution = HTML('Maps by <a href="http://www.mapbox.com/">Mapbox</a>'),
      options=list(
        center = c(25.038580, 121.544054),
        zoom = 9,
        maxBounds = list(list(17, -180), list(59, 180))))), 
  fluidRow(htmlOutput("Click_text"))
)
)
