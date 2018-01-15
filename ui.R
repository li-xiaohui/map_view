
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#
library(shiny)
library(leaflet)
library(shinydashboard)
library(ggplot2)
library(dplyr)


shinyUI(
  dashboardPage(title = "Station Lookup",
                dashboardHeader(title = "Test"),
                dashboardSidebar(
                  sidebarMenu(
                    menuItem("Data Dashboard", tabName = "datavis", icon = icon("dashboard")),
                    # menuItem("Select by station number", icon = icon("bar-chart-o"),
                    #          selectizeInput("stations", "Click on Station", 
                    #                         choices = levels(factor(quakes$stations)), 
                    #                         selected = 10, multiple = TRUE)
                    
                    menuItem("Select by Branch Code", icon = icon("bar-chart-o"),
                             selectizeInput("branch_code", "Click on Branch",
                                            choices = levels(factor(recent_rated_branches$Branch.Code)),
                                            selected = 16)
                    )
                  )
                ),
                dashboardBody(
                  tabItems(
                    tabItem(tabName = "datavis",
                            h4("Map and Plot"),
                            fluidRow(box(width= 6,  leafletOutput("map")),
                                     # box(width = 6, plotOutput("plot"))
                                     box(width = 6, textOutput("click_text"))
                                     )
                    )
                  )
                )
)
)