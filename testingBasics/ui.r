library(shiny)
source("../ingredients.R")
# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("The Best Light and Fluffy Buttermilk Pancakes"),
  
  fluidRow(
    column(width = 4, 
           h1("eggnogr"),
           p(
             a("Recipe from ", 
               href = "https://http://www.seriouseats.com/recipes/2010/06/light-and-fluffy-pancakes-recipe.html"), 
             a("J. Kenji López-Alt", href = "https://twitter.com/kenjilopezalt"), 
             ".", br(),
             "Scaling by Hadley Wickham, R, and ", 
             a("shiny", href = "http://shiny.rstudio.com"), "."),
           p("How much eggnog do you want?"),
           numericInput("quantity", "", 1, min = 1),
           selectInput("units", "", names(units)),
           checkboxInput("variation", "Clyde common variation? (no rum)"),
           checkboxInput("nice", "Nice numbers? (makes vol approx)", TRUE),
           checkboxInput("metric", "Would you like metric units?")
    ),
    column(width = 8,
           h2("Ingredients"),
           tableOutput("ingredients"),  
           p("(all units by volume, not weight)"),
           h2("Instructions"),
           tags$ol(
             tags$li("Beat eggs in blender for one minute on medium speed."),
             tags$li("Slowly add sugar and blend for one additional minute."),
             tags$li("With blender still running, add nutmeg, brandy, rum, milk and cream until combined."),
             tags$li("Chill thoroughly to allow flavors to combine."),
             tags$li("Serve in chilled wine glasses or champagne coupes, grating additional ",
                     "nutmeg on top immediately before serving.")
           )
    )
  ),
  p(a("Read the source", href = "https://github.com/hadley/eggnogr"))
))
  )
))