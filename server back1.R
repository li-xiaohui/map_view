
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(leaflet)
# 
# # df <- data.frame()
# # latitude <- c(35.94077, 35.83770, 35.84545, 35.81584, 35.79387, 36.05600, 24.813803)
# latitude <- c(24.800980, 25.038580, 22.987791, 24.813803)
# # longitude <- c(-78.58010, -78.78084, -78.72444, -78.62568, -78.64262, -78.67600, )
# longitude <- c(120.961275, 121.544054, 120.191830,  120.963519)
# ids<- c('Xinxing Branch', 'Renai Branch', 'Tainan Branch', 'Zhongzheng Branch')
# risk_rating<- c('Low', 'Low', 'Middle', 'High')
# df<- data.frame(ids = ids, latitude = latitude, longitude=longitude, risk_rating=risk_rating)
# 
# str(df)
# # radius<-c(15, 12, 12, 12, 12, 15)
# # ids<-c("a", "b", "c", "d", "e", "f")

library(readxl)
# library(dplyr)
branches <- read_excel('branches.xlsx')
names(branches) <- make.names(names(branches))
str(branches)

getColor <- function(branches) {
  sapply(branches$Risk.Rating, function(rating) {
    if(rating == 'Low') {
      "green"
    } else if(rating == 'Middle') {
      "orange"
    } else {
      "red"
    } })
}
icons <- awesomeIcons(
  icon = 'ios-close',
  iconColor = 'black',
  library = 'ion',
  markerColor = getColor(branches)
)


shinyServer(function(input, output, session) {

  map = createLeafletMap(session, 'map')
  session$onFlushed(once=T, function(){
    
    map$addMarker(lat = branches$Lat, 
                        lng = branches$Lon, 
                        # icon = icons,
                        layerId=branches$Name.of.Branch)
    
#     map$addMarker(lat = df$latitude, 
#                         lng = df$longitude, 
#                         # radius = radius, 
#                         layerId=df$ids)
  
#     leaflet(branches) %>% addTiles() %>%
#       addAwesomeMarkers(~Lat, ~Lon, icon=icons, layerId= ~Name.of.Branch, label=~as.character(Chinese.Name))
#     
#     leaflet(branches) %>% addTiles() %>%
#       addAwesomeMarkers(~Lat, ~Lon, label = ~Name.of.Branch)
    
  })        
  
  #observe provides events after the markers are clicked
  observe({
    click<-input$map_marker_click
    if(is.null(click))
      return()
    text<-paste("Lattitude ", click$lat, "Longtitude ", click$lng)
    # branch_data <- branches[branches$Name.of.Branch == click$id, ]
    # text2<-paste("Branch:", click$id, ' Risk Rating: ', branch_data$Risk.Rating)
    
    # No need to show pop up
#     map$clearPopups()
#     map$showPopup( click$lat, click$lng, text)

    output$Click_text<-  renderUI({
      branch_data <- branches[branches$Name.of.Branch == click$id, ]
      
      str1 <- paste("Branch:", branch_data$Chinese.Name, '(', click$id, ')')
      str2 <- paste('Risk Rating: ', branch_data$Risk.Rating)
      HTML(paste(str1, str2, sep = '<br/>'))
    })
    
  })

})
