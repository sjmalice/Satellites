#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
library(shiny)
library(shinydashboard)

# Define UI for application that draws a histogram
shinyUI(dashboardPage(
  dashboardHeader(title = "Active Satellites"),
  dashboardSidebar(
    sidebarUserPanel("Simon Joyce"),
    sidebarMenu(
      menuItem("Map", tabName = 'map', icon = icon('map'))
    )
    ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "map",
              fluidRow(
                box(
                  sliderInput(
                    "dates",
                    label = h3("Launch Date Range"),
                    min = 1974, 
                    max = 2016,
                    value = c(1974, 2016)
                  ) 
                )
              ),
              fluidRow(
                box(htmlOutput("map"))
                )
      )
    )
  )
))

