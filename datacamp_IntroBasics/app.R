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
# get data
load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))

## Define UI for application that plots features of movies 
## Inputs, user selections, and outputs are laid out here 
ui <- 
  # makes page consisting of rows (elements on same line) and cols (allots horizontal space for each row element)
  # scales components in real-time to fill all available browser width
  fluidPage( 
  
  # Default Sidebar layout ==  definitions for sidebar for inputs and main area for outputs
  sidebarLayout(
    
    # Define Inputs and input controls
    sidebarPanel(
      
      #  definitions = Select variable for y-axis
      selectInput(inputId = "y", 
                  label = "Y-axis:",
                  choices = c("imdb_rating", "imdb_num_votes", "critics_score", "audience_score", "runtime"), 
                  selected = "audience_score"), # default choice
      #  definitions = Select variable for x-axis
      selectInput(inputId = "x", 
                  label = "X-axis:",
                  choices = c("imdb_rating", "imdb_num_votes", "critics_score", "audience_score", "runtime"), 
                  selected = "critics_score"), # default choice
      # Select variable for color
      selectInput(inputId = "z", 
                  label = "Color by:",
                  choices = c("title_type", "genre", "mpaa_rating", "critics_rating", "audience_rating"),
                  selected = "mpaa_rating")
    ),
    
    # Sepcify area that contains Outputs
    mainPanel(
      plotOutput(outputId = "scatterplot")
    )
  )
)

## Define server logic and instructions to build app
## CALCULATES outputs and any other calculations needed for outputs to be performed
server <- function(input, output) {
  
  ### Render a reactive plot suitable for assigning to an output slot.
  # Create scatterplot object that the plotOutput function is expecting
  output$scatterplot <- renderPlot({ 
        ggplot(data = movies, aes_string(x = input$x, y = input$y, color = input$z)) +
      geom_point()
  })
}

# Run the application and create shiny object
shinyApp(ui = ui, server = server)