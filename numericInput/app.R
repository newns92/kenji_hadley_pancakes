#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(shiny)
library(dplyr)
library(DT)
## get data
load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))

## Calculate total number of movies in dataset before the UI definition (scoping)
n_total <- nrow(movies)

# Define UI for application that plots features of movies
ui <- fluidPage(
  
  # Sidebar layout with a input and output definitions
  sidebarLayout(
    
    # Inputs
    sidebarPanel(
      
      # Text instructions
      HTML(paste("Enter a value between 1 and", n_total)),
      
      # Numeric input for sample size (number of records to show)
      numericInput(inputId = "n",
                   label = "Sample size:",
                   min = 1,
                   max = n_total,
                   value = 30,
                   step = 1)
      
    ),
    
    # Output: Show data table
    mainPanel(
      DT::dataTableOutput(outputId = "moviestable")
    )
  )
)

# Define server function required to create the scatterplot
server <- function(input, output) {
  
  # Create data table
  output$moviestable <- DT::renderDataTable({
    ## require a value for the sample size
    req(input$n)
    
    # randomly sample some data
    movies_sample <- movies %>%
      sample_n(input$n) %>%
      select(title:studio) # specify columns to show
    DT::datatable(data = movies_sample, 
                  options = list(pageLength = 10), # show 10 records by default
                  rownames = FALSE)
  })
  
}

# Create a Shiny app object
shinyApp(ui = ui, server = server)