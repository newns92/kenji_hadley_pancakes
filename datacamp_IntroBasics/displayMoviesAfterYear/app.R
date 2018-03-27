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
library(ggplot2)
load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))

min_date <- min(movies$thtr_rel_date)
max_date <- max(movies$thtr_rel_date)

# Define UI for application that displays movies in table for selected movie studios
ui <- fluidPage(
  
  sidebarLayout(
    
    # Input(s)
    sidebarPanel(
      # Explanatory text
      HTML(paste0("Movies released between the following dates will be plotted. 
                  Pick dates between ", min_date, " and ", max_date, ".")),
      
      # Break for visual separation
      br(), br(),
      
      # Date input
      dateRangeInput(inputId = "date",
                label = "Select dates:",
                start = "2013-01-01",
                end = "2014-01-01",
                min = min_date, max = max_date,
                startview = "year") # date range shown when the input object is first clicked
    ),
    
    # Output of a scatterplot of audience score by critics score for movies after selected year
    mainPanel(
      plotOutput(outputId = "scatterplot")
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  # Create the plot
  output$scatterplot <- renderPlot({
    req(input$date) # require inputs for start + end dates in dateRangeInput
    movies_selected_date <- movies %>%
      filter(thtr_rel_date >= as.POSIXct(input$date[1]) & thtr_rel_date <= as.POSIXct(input$date[2])) # get movies between selected dates
    
    # plot the scores for filtered movies
    ggplot(data = movies_selected_date, aes(x = critics_score, y = audience_score, color = mpaa_rating)) +
      geom_point()
  })
  
}

# Create a Shiny app object
shinyApp(ui = ui, server = server)