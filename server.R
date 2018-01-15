
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(leaflet)
library(ggplot2)
library(dplyr)
library(readxl)
library(data.table)

# # 
branches <- data.table(read_excel('branches.xlsx'))
branch_loc<- read_excel('branch_lat_lon.xlsx')
names(branches) <- make.names(names(branches))
names(branch_loc ) <- make.names((names(branch_loc)))

str(branches)
str(branch_loc)

recent_rated_branches<- branches[Quarter  == '2017Q4'] %>%
  merge(branch_loc[, c('Branch.Code', 'Lat', 'Lon')], by='Branch.Code')
# 
# getColor <- function(branches) {
#   sapply(branches$Risk.Rating, function(rating) {
#     if(rating == 'Low') {
#       "green"
#     } else if(rating == 'Middle') {
#       "orange"
#     } else {
#       "red"
#     } })
# }

df.20 <- quakes[1:20,]

getColor <- function(quakes) {
  sapply(quakes$mag, function(mag) {
    if(mag <= 4) {
      "green"
    } else if(mag <= 5) {
      "orange"
    } else {
      "red"
    } })
}

getColorBranch <- function(branches) {
  as.vector(
      # assuming 2017Q4 the latest quarter
    sapply(branches$Risk.Rating, function(rating) {
    if(rating == 'Low') {
            "green"
          } else if(rating == 'Middle') {
            "orange"
          } else {
            "red"
          } })
  )
}

icons <- awesomeIcons(
  icon = 'ios-close',
  iconColor = 'black',
  library = 'ion',
  markerColor = getColor(df.20)
)


iconsBranch <- awesomeIcons(
  icon = 'ios-close',
  iconColor = 'black',
  library = 'ion',
  markerColor = getColorBranch(recent_rated_branches)
)


## new edit

shinyServer(function(input, output, session) {
  ## Sub data     
  quakes_sub <- reactive({
    #make input$stations to be one item
    # df.20[df.20$stations  == input$stations,]
    recent_rated_branches[Branch.Code == input$branch_code]
    
  })  
  
  output$click_text <- renderText({
    # quakes_sub()$stations
    quakes_sub()$Name.of.Branch
    
  })
  
  
  output$map <- renderLeaflet({
    # leaflet(df.20) %>% 
    leaflet(recent_rated_branches) %>% 
      addTiles() %>%
      # addMarkers(lng = ~long, lat = ~lat, layerId = ~stations) %>%
      # addCircles(lng = ~long, lat = ~lat, weight = 1,
      #            radius = 1, label = ~stations, 
      #            popup = ~paste(stations, "<br>",
      #                           depth, "<br>",
      #                           mag)
      # addAwesomeMarkers(~long, ~lat, icon=icons, label=~as.character(mag)
      addAwesomeMarkers(~Lon, ~Lat, icon=iconsBranch, label=~as.character(Name.of.Branch)
      )
    
  })
  
  # observeEvent(input$stations, {
  #   updateSelectInput(session, "stations", "Click on Station", 
  #                     choices = levels(factor(quakes$stations)), 
  #                     selected = c(input$stations))
  # })
  
  observeEvent(input$branch_code, {
    updateSelectInput(session, "branch_code", "Click on Station", 
                      choices = levels(factor(recent_rated_branches$Branch.Code)),
                      selected = c(input$branch_code))
  })
  
  # observeEvent(input$map_marker_click, {
  #   click <- input$map_marker_click
  #   station <- quakes[which(quakes$lat == click$lat & quakes$long == click$lng), ]$stations
  #   updateSelectInput(session, "stations", "Click on Station", 
  #                     choices = levels(factor(quakes$stations)), 
  #                     # selected = c(input$stations, station)
  #                     selected = station
  #                     )
  # })
  
  observeEvent(input$map_marker_click, {
    click <- input$map_marker_click
    # station <- quakes[which(quakes$lat == click$lat & quakes$long == click$lng), ]$stations
    branch <- recent_rated_branches[Lat == click$lat & Lon == click$lng]$Branch.Code
    updateSelectInput(session, "branch_code", "Click on Branch", 
                      choices = levels(factor(recent_rated_branches$Branch.Code)),
                      # selected = c(input$stations, station)
                      selected = branch
    )
  })
  
  
})

