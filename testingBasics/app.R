#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
source("../ingredients.r")

# Define UI for application that draws a histogram
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
             a(img(src = "https://www.rstudio.com/wp-content/uploads/2014/04/shiny.png", height = "30px"),
               href = "https://www.r-project.org/"),
             "by",
             a(img(src = "https://www.rstudio.com/wp-content/uploads/2014/07/RStudio-Logo-Blue-Gray.png", height = "30px"),
               href = "http://shiny.rstudio.com"),
             "."),
           
           #p("How many people?"),
           numericInput(inputId =  "quantity"
                        ,label = "How many people?"
                        ,value = 1  # default value
                        ,min = 1),
           
           p("(1 serving makes four 6-inch pancakes)"),
           
           selectInput(inputId = "units"
                       ,label = "Substitutions if no buttermilk"
                       ,choices = c("None", "sour cream", "yogurt", "creme fraiche")
                       ,selected = "None")#, #names(units)),
           
           #checkboxInput("variation", "Clyde common variation? (no rum)"),
           #checkboxInput("nice", "Nice numbers? (makes vol approx)", TRUE),
           # checkboxInput("metric", "Would you like metric units?")
    ),
      
      # Show a plot of the generated distribution
      mainPanel(
        tableOutput(outputId = "ingredients")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  source("../ingredients.r")
  
  #dry <- data.frame(
   # quantity = c(10, 1, 0.5, 1, 1),
  #  unit = c("oz", "tsp", "tsp", "tsp", "tbsp"),
   # ingredient = c("All-Purpose Flour", "Baking Powder", "Baking Soda",
   #                "Kosher Salt", "Sugar"),
   # stringsAsFactors = FALSE
  #)
  
  output$ingredients <- renderTable({
    dry
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

