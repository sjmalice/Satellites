#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(googleVis)

data = read_csv('./satellites.csv')
#replace single entry of Earth/Space Science with Earth Science/Space Science
data$Purpose = gsub('Earth/', 'Earth Science/', data$Purpose)
#fix messy users column
data$Users = gsub("Commerical", "Commercial", data$Users)
data$Users = gsub("Gov/Mil", "Government/Military", data$Users)
#format date column
data$`Date of Launch` = parse_date(data$`Date of Launch`, '%m/%d/%Y')
#add year column for filtering
data = data %>%
  mutate(year = as.integer(substr(`Date of Launch`,1, 4)))

#find positions of users
User_pos = list(
  civ_pos = grep("Civil", data$Users),
  com_pos = grep("Commercial", data$Users),
  mil_pos = grep("Military", data$Users),
  gov_pos = grep("Government", data$Users)
)

purpose_categories = c("Communications",
                       "Earth Observation",
                       "Technology Development",
                       "Navigation",
                       "Space Science",
                       "Earth Science",
                       "Technology Demonstration",
                       "Space Observation")

#functions to find list of unique instances within a column separated by /
list_sep = function(column){
  column %>% 
    strsplit('/') %>% 
    unlist() %>% 
    unique()
}

#function to build data frames for gvis

fill_table = function(list, column){
  d_f = data.frame(
    names = list
  )
  
  d_f = d_f %>% 
    mutate(
      pos = sapply(list, function(x){
        grep(x, column)
      }),
      Total = lengths(pos),
      Civil = sapply(pos, function(x){
        length(intersect(x, User_pos$civ_pos))
      }),
      Commercial = sapply(pos, function(x){
        length(intersect(x, User_pos$com_pos))
      }),
      Military = sapply(pos, function(x){
        length(intersect(x, User_pos$mil_pos))
      }),
      Government = sapply(pos, function(x){
        length(intersect(x, User_pos$gov_pos))
      })
    )
}

shinyServer(function(input, output) {
  #filter satellites by users selected
  user_slice = reactive({
    sort(
      unique(
        unlist(User_pos[as.integer(input$users)], use.names = F)
      ))
  })
  #filter satelites by date input and selected users
  temp = reactive({
    data[user_slice(),] %>%
      filter(between(year, input$dates[1], input$dates[2]))
  })
  
  output$map <- renderGvis({
    
    data_map = fill_table(
      list_sep(temp()$`Country of Operator/Owner`),
      temp()$`Country of Operator/Owner`
    )
    
    map_options = list(
      region = "world",
      displayMode = "regions",
      resolution = "countries",
      colorAxis = '{colors: ["yellow", "red"]}',
      # colorAxis = '{values:[0, 64, 589],colors: ["yellow", "red", "blue"]}',
      width="auto",
      height="auto")
    
    data_map %>% 
      gvisGeoChart(locationvar = "names",
                   colorvar = 'Total',
                   # hovervar = "Military",
                   options = map_options
        )
  })
  output$bar = renderGvis({
    #data frame for bar chart
    data_bar = fill_table(
      intersect(list_sep(temp()$Purpose), purpose_categories),
      temp()$Purpose
    )

    data_bar %>%
      arrange(desc(Total)) %>%
      gvisBarChart(
        xvar = "names",
        yvar = c("Civil", "Commercial", "Military", "Government"),
        options=list(title="Purposes and Users",
                     isStacked = TRUE,
                     legend="bottom",
                     width="auto",
                     height="auto")
      )
  })
})


