library(shiny)
library(ggplot2)
library(tidyverse)

load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))

# Define UI for app w/ inputs, user selections, and outputs
ui <- 
  # make page consisting of rows (elements on same line) + cols (horizontal space for each row element)
  # scales components in real-time to fill all available browser width
  fluidPage(
  
    sidebarLayout( 
    
      # Input(s) 
      sidebarPanel(
        
        # Select variable for y-axis
        selectInput(inputId = "y",
                    label = "Y-axis:",
                    choices = c("imdb_rating", "imdb_num_votes", "critics_score", "audience_score", "runtime"), 
                    selected = "audience_score"),
        
        # Select variable for x-axis
        selectInput(inputId = "x", 
                    label = "X-axis:",
                    choices = c("imdb_rating", "imdb_num_votes", "critics_score", "audience_score", "runtime"), 
                    selected = "critics_score")
      ),
      
      # Outputs
      mainPanel(
        plotOutput(outputId = "scatterplot", brush = "plot_brush"), # allow user to draw rectangle over DP's in a plot to send to server
        textOutput(outputId = "correlation"),
        # show data table from brush
        DT::dataTableOutput(outputId = "moviestable")
      )
    )
)

## Define server logic and relationships between inputs and outputs and create instructions to build app
## CALCULATES outputs and any other calculations needed for outputs to be performed
server <- function(input, output) {
  
  # Create scatterplot object the plotOutput function is expecting
  output$scatterplot <- renderPlot({
    ggplot(data = movies, aes_string(x = input$x, y = input$y)) +
      geom_point()
  })
  
  # Create text output stating the correlation between the two plotted variables
  output$correlation <- renderText({
    pearsonsr <- round(cor(movies[,input$x], movies[,input$y], use = "pairwise"), 3)
    paste0("Correlation = ", pearsonsr, ". Note: If the relationship between the two variables is not linear, the correlation coefficient will not be meaningful.")
  })
  
  # Print data table from brushing
  output$moviestable <- DT::renderDataTable({
    brushedPoints(movies, input$plot_brush) %>% # get DP's from user's rectangle as rows from a data frame (brushed pts = helper function)
      select(title, audience_score, critics_score)
  })
}

# Create a Shiny app object
shinyApp(ui = ui, server = server)