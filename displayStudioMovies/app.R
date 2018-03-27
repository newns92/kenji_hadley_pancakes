#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(shiny)
library(ggplot2)
library(dplyr)
library(DT)
load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))
all_studios <- sort(unique(movies$studio))

# Define UI for application that displays movies in table for selected movie studios
ui <- fluidPage(
   
    sidebarLayout(
    
    # Input(s)
    sidebarPanel(
      selectInput(inputId = "studio",
                  label = "Select studio:",
                  choices = all_studios,
                  selected = "20th Century Fox",
                  selectize = T, # T by default
                  multiple = T) # enable multiple selections
      
    ),
      
    # Output of a data table
    mainPanel(
      DT::dataTableOutput(outputId = "moviestable")
    )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  # Create data table
  output$moviestable <- DT::renderDataTable({
    ## require a value for the sample size
    req(input$studio)
    
    # filter movies based on input
    movies_from_selected_studios <- movies %>%
      filter(studio %in% input$studio) %>% # get just movies from selected studio(s) from input
      select(title:studio) # specify columns to show
    
    # make table
    DT::datatable(data = movies_from_selected_studios, 
                  options = list(pageLength = 10), # show 10 records by default
                  rownames = FALSE)
  })
  
}

# Create a Shiny app object
shinyApp(ui = ui, server = server)