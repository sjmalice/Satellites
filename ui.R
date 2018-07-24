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
    sidebarUserPanel("Simon Joyce",
                     image = "https://yt3.ggpht.com/-04uuTMHfDz4/AAAAAAAAAAI/AAAAAAAAAAA/Kjeupp-eNNg/s100-c-k-no-rj-c0xffffff/photo.jpg"),
    sidebarMenu(
      menuItem("Intro", tabName = "intro", icon = icon("file")),
      menuItem("Map", tabName = 'map', icon = icon('map')),
      menuItem("Purposes", tabName = 'bar', icon = icon('chart-bar')),
      menuItem("Orbits", tabName = 'orbits', icon = icon('globe'))
      ),
    fluidRow(
        sliderInput(
          "dates",
          label = h3("Launch Year Range"),
          min = 1990, 
          max = 2016,
          value = c(1974, 2016)
          )
      ),
    fluidRow(
      checkboxGroupInput("users", label = h3("Users"), 
                         choices = list("Civil" = 1,
                                        "Commercial" = 2,
                                        "Military" = 3,
                                        "Government" = 4
                                        ),
                         selected = c(1, 2, 3, 4)
      )
      )
    ),
  dashboardBody(
    tabItems(
      tabItem(
        tabName = 'intro',
        fluidRow(
          box(
            tags$h1("Active Satellites in Orbit"),
            tags$p("Explore questions about all of the active satellites in orbit."),
            tags$p("How many satellites does each country claim?"),
            tags$p("What do we use the satellites for and how many do we use for each purpose?"),
            tags$p("What kind of satellites occupy different kinds of orbits?"),
            tags$p("Answers to these questions, and more, lie within this Shiny App."),
            tags$p("Find filters for year of launch and operating body in the side-panel"),
            tags$a(href = 'https://github.com/sjmalice/Satellites', "Github link for this Shiny App."),
            width = 12
          )
        )
      ),
      tabItem(tabName = "map",
              fluidRow(
                box(tags$h1("Satellites Owned by Country"), width = 12)
              ),
              fluidRow(
                box(htmlOutput("map"), width = 12)
                )
      ),
      tabItem(tabName = "bar",
              fluidRow(
                box(tags$h1("Satellites by Purpose and Operating Bodies"), width = 12)
              ),
              fluidRow(
                box(htmlOutput("bar"), width = 12)
              )
      ),
      tabItem(tabName = "orbits",
              fluidRow(
                box(tags$h1("Satellites by Orbit Type and Purpose"),
                    tags$p("LEO : Low Earth Orbit"),
                    tags$p("MEO : Medium Earth Orbit"),
                    tags$p("GEO : Geosynchronous Earth Orbit"),
                    width = 12)
              ),
              fluidRow(
                box(htmlOutput('orbits'), width = 12)
              ))
    )
  )
))

