#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
source("./ingredients.r")

# Define UI for application
ui <- fluidPage(
 
  # Application title
  titlePanel("The Best Light and Fluffy Buttermilk Pancakes"),
  
  fluidRow(
    column(width = 4, 
           p(
             a("Recipe ",
               href = "https://http://www.seriouseats.com/recipes/2010/06/light-and-fluffy-pancakes-recipe.html"), 
             "from ", 
             a("J. Kenji López-Alt", href = "https://twitter.com/kenjilopezalt"), 
             "."
            ),
           p("Application inspired by",
             a("eggnogr", href = "https://hadley.shinyapps.io/eggnogr/"), 
             ", developed ", 
             a("Hadley Wickham", href = "https://twitter.com/hadleywickham"), 
             ", with the help of ",
             a("R", href = "https://www.r-project.org/"),
             "and ",
             a("Shiny", href = "http://shiny.rstudio.com"), "."),
           
           p("How many people?"),
           numericInput("quantity", "", 1, min = 1),
           p("(Makes 'xx' 6-inch pancakes)"),
           selectInput(
             inputId = "units",
             label = "Substitutions if no buttermilk",
             choices = c("None", "sour cream", "yogurt", "creme fraiche"),
             selected = "None"), #names(units)),
           
           checkboxInput("variation", "Clyde common variation? (no rum)"),
           checkboxInput("nice", "Nice numbers? (makes vol approx)", TRUE),
           checkboxInput("metric", "Would you like metric units?")
    ),
    column(width = 5,
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
  
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
  ingredients <- reactive(
    if (input$dry) dry else dry      
  )
  
  scaled <- reactive({
    df <- scale(ingredients(), input$quantity, grams = input$grams,
                ml = input$ml)
    df$quantity <- format(df$quantity, drop0trailing = TRUE)
    df
  })
  
  output$ingredients <- renderTable(scaled(), 
                                    align = "rrll",
                                    include.rownames = FALSE,
                                    include.colnames = FALSE)
   
}

# Run the application (ALWAYS LAST LINE IN FILE)
shinyApp(ui = ui, server = server)

