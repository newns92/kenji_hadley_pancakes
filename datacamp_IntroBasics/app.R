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
## get data (outside UI + server definitions)
load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))
# data is now visible to UI and to server + we can refer to it by name to plot it

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
                  choices = c("IMDB Rating" = "imdb_rating", 
                              "IMDB number of votes" = "imdb_num_votes", 
                              "Critics score" = "critics_score", 
                              "Audience score" = "audience_score", 
                              "Runtime" = "runtime"), 
                  selected = "audience_score"), # default choice
      #  definitions = Select variable for x-axis
      selectInput(inputId = "x", 
                  label = "X-axis:",
                  choices = c("IMDB Rating" = "imdb_rating", 
                              "IMDB number of votes" = "imdb_num_votes", 
                              "Critics score" = "critics_score", 
                              "Audience score" = "audience_score", 
                              "Runtime" = "runtime"), 
                  selected = "critics_score"), # default choice
      # Select variable for color
      selectInput(inputId = "z", 
                  label = "Color by:",
                  choices = c("Title type" = "title_type",
                              "Genre" = "genre",
                              "MPAA rating" = "mpaa_rating",
                              "Critics rating" = "critics_rating",
                              "Audience rating" = "audience_rating"),
                  selected = "mpaa_rating"),
      
      ## new input widget = sliderbar to set the alpha level
      # Set alpha level
      sliderInput(inputId = "alpha", 
                  label = "Alpha:", 
                  min = 0, max = 1, 
                  value = 0.5),
    
      ## new input widget = show as a table checkbox
      checkboxInput(inputId = "show_data", 
                  label = "Show data table:", 
                  value = TRUE)
    ),
  
    
    # Sepcify area that contains Outputs
    mainPanel(
      plotOutput(outputId = "scatterplot"),
      # add 2nd plot w/ specified height
      plotOutput(outputId = "densityplot", height = 200),
      # add 3rd object = data table if checkbox = TRUE
      DT::dataTableOutput(outputId = "moviestable")
    )
  )
)

## Define server logic and relationships between inputs and outputs and create instructions to build app
## CALCULATES outputs and any other calculations needed for outputs to be performed
server <- function(input, output) {
  
  ### Render a reactive plot suitable for assigning to an output slot.
  # Create scatterplot object that the plotOutput function is expecting
  # uses inputs built in ui()
  output$scatterplot <- renderPlot({ 
        ggplot(data = movies, aes_string(x = input$x, y = input$y, color = input$z)) +
      geom_point(alpha = input$alpha)
  })
  
  ## Create density plot
  output$densityplot <- renderPlot({
    ggplot(data = movies, aes_string(x = input$x)) +
      geom_density()
  })
  
  ## Create data table
  output$moviestable <- DT::renderDataTable({
    if (input$show_data) {
      DT::datatable(data = movies %>% select(1:7), # show 1st 7 columns
                    options = list(pageLength = 10), # default number of records to show
                    rownames = FALSE)
    }
  })
  
}

# Run the application and create shiny object
shinyApp(ui = ui, server = server)