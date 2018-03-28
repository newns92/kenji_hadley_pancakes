library(shiny)
library(ggplot2)
library(dplyr)
load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))

# UI
ui <- fluidPage(
  sidebarLayout(
    
    # Input(s)
    sidebarPanel(
      
      # Select variable for y-axis
      selectInput(inputId = "y", 
                  label = "Y-axis:",
                  choices = c("IMDB rating" = "imdb_rating", 
                              "IMDB number of votes" = "imdb_num_votes", 
                              "Critics Score" = "critics_score", 
                              "Audience Score" = "audience_score", 
                              "Runtime" = "runtime"), 
                  selected = "audience_score"),
      
      # Select variable for x-axis
      selectInput(inputId = "x", 
                  label = "X-axis:",
                  choices = c("IMDB rating" = "imdb_rating", 
                              "IMDB number of votes" = "imdb_num_votes", 
                              "Critics Score" = "critics_score", 
                              "Audience Score" = "audience_score", 
                              "Runtime" = "runtime"), 
                  selected = "critics_score"),
      
      # Select variable for color
      selectInput(inputId = "z", 
                  label = "Color by:",
                  choices = c("Title Type" = "title_type", 
                              "Genre" = "genre", 
                              "MPAA Rating" = "mpaa_rating", 
                              "Critics Rating" = "critics_rating", 
                              "Audience Rating" = "audience_rating"),
                  selected = "mpaa_rating"),
      
      # Select which types of movies to plot
      checkboxGroupInput(inputId = "selected_type",
                         label = "Select movie type(s):",
                         choices = c("Documentary", "Feature Film", "TV Movie"),
                         selected = "Feature Film"),
      
      # Select sample size
      numericInput(inputId = "n_samp", 
                   label = "Sample size:", 
                   min = 1, max = nrow(movies), 
                   value = 3)
    ),
    
    # Output(s)
    mainPanel(
      plotOutput(outputId = "scatterplot"),
      uiOutput(outputId = "n")
    )
  )
)

# Server
server <- function(input, output) {
  
  # Create a subset of data filtering for selected title types
  movies_subset <- reactive({
    req(input$selected_type)
    filter(movies, title_type %in% input$selected_type)
  })
  
  # Create new df that is n_samp obs from selected type movies
  movies_sample <- reactive({ 
    req(input$n_samp)
    sample_n(movies_subset(), input$n_samp)
  })
  
  # Create scatterplot object the plotOutput function is expecting
  output$scatterplot <- renderPlot({
    ggplot(data = movies_sample(), aes_string(x = input$x, y = input$y, color = input$z)) +
      geom_point()
  })
  
  # Print number of movies plotted
  output$n <- renderUI({
    types <- movies_sample()$title_type %>% 
      factor(levels = input$selected_type) 
    counts <- table(types)
    HTML(paste("There are", counts, input$selected_type, "movies plotted in the plot above. <br>"))
  })
  
}

# Create a Shiny app object
shinyApp(ui = ui, server = server)


# library(shiny)
# library(ggplot2)
# library(dplyr)
# library(tools)
# load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))
# 
# # Define UI for application that plots features of movies
# ui <- fluidPage(
#   
#   # Application title
#   titlePanel("Movie browser"),
#   
#   # Sidebar layout with a input and output definitions
#   sidebarLayout(
#     
#     # Inputs(s)
#     sidebarPanel(
#       
#       # Select variable for y-axis
#       selectInput(inputId = "y", 
#                   label = "Y-axis:",
#                   choices = c("IMDB rating" = "imdb_rating", 
#                               "IMDB number of votes" = "imdb_num_votes", 
#                               "Critics Score" = "critics_score", 
#                               "Audience Score" = "audience_score", 
#                               "Runtime" = "runtime"), 
#                   selected = "audience_score"),
#       
#       # Select variable for x-axis
#       selectInput(inputId = "x", 
#                   label = "X-axis:",
#                   choices = c("IMDB rating" = "imdb_rating", 
#                               "IMDB number of votes" = "imdb_num_votes", 
#                               "Critics Score" = "critics_score", 
#                               "Audience Score" = "audience_score", 
#                               "Runtime" = "runtime"), 
#                   selected = "critics_score"),
#       
#       # Select variable for color
#       selectInput(inputId = "z", 
#                   label = "Color by:",
#                   choices = c("Title Type" = "title_type", 
#                               "Genre" = "genre", 
#                               "MPAA Rating" = "mpaa_rating", 
#                               "Critics Rating" = "critics_rating", 
#                               "Audience Rating" = "audience_rating"),
#                   selected = "mpaa_rating"),
#       
#       # Enter text for plot title
#       textInput(inputId = "plot_title", 
#                 label = "Plot title", 
#                 placeholder = "Enter text for plot title"),
#       
#       # Select which types of movies to plot
#       checkboxGroupInput(inputId = "selected_type",
#                          label = "Select movie type(s):",
#                          choices = c("Documentary", "Feature Film", "TV Movie"),
#                          selected = "Feature Film")
#       
#     ),
#     
#     # Output(s)
#     mainPanel(
#       plotOutput(outputId = "scatterplot"),
#       textOutput(outputId = "description")
#     )
#   )
# )
# 
# # Server
# server <- function(input, output) {
#   
#   # Create a subset of data filtering for selected title types
#   movies_subset <- reactive({
#     req(input$selected_type)
#     filter(movies, title_type %in% input$selected_type)
#   })
#   
#   # Convert plot_title toTitleCase
#   pretty_plot_title <- reactive({
#     toTitleCase(input$plot_title)
#   })
#   
#   # Create scatterplot object the plotOutput function is expecting
#   output$scatterplot <- renderPlot({
#     ggplot(data = movies_subset(), 
#            aes_string(x = input$x, y = input$y, color = input$z)) +
#       geom_point() +
#       labs(title = pretty_plot_title())
#   })
#   
#   # Create descriptive text
#   output$description <- renderText({
#     paste0("The plot above titled '", pretty_plot_title(), "' visualizes the relationship between ", input$x,
#            " and ", input$y, ", conditional on ", input$z, ".")
#   })
#   
# }
# 
# # Create the Shiny app object
# shinyApp(ui = ui, server = server)