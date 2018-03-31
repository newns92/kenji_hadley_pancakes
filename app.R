library(shiny)

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
             a(img(src = "https://www.rstudio.com/wp-content/uploads/2014/04/shiny.png", height = "30px"),
                href = "https://www.r-project.org/"),
             "by",
             a(img(src = "https://www.rstudio.com/wp-content/uploads/2014/07/RStudio-Logo-Blue-Gray.png", height = "30px"),
                href = "http://shiny.rstudio.com"),
              "."),
           
           #p("How many people?"),
           numericInput(inputId =  "quantity"
                        ,label = "How many servings?"
                        ,value = 1  # default value
                        ,min = 1),
           
           p("(1 serving makes four 6-inch pancakes)"),
           
           selectInput(inputId = "wet_base"
                       ,label = "Substitutions if no buttermilk"
                       ,choices = c("None", "sour cream", "yogurt", "creme fraiche")
                       ,selected = "None"),
           
           #checkboxInput("ml", "Using mL?", F),
           checkboxInput("ml", "Using mL?", F),
           checkboxInput("grams", "Use weight (grams)", T)
    ),
    column(width = 5,
           h3("Dry Ingredients"),
           tableOutput(outputId = "dry_ingredients"),  
           h3("Wet Ingredients"),
           tableOutput(outputId = "wet_ingredients"), 
           tableOutput(outputId = "syrup"),
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
  source("./ingredients.r")
  
  # create a reactive data frame based on which type of ingredients are chosen
  dry_ingredients_df <- reactive(
    dry
  )
  wet_ingredients_df <- reactive(
    if (input$wet_base == "sour cream") sourCream 
    else if (input$wet_base == "yogurt") yogurt
    else if (input$wet_base == "creme fraiche") cremeFraiche
    else buttermilk
  )
  
  scaled_dry <- reactive({
    # use reactive dataframe as input for scale function from ingredients.R file
    df <- scale(dry_ingredients_df(), input$quantity, grams = T,#input$grams,
                ml = F)#input$ml)
    df$quantity <- format(df$quantity, drop0trailing = TRUE)
    df
  })
  scaled_wet <- reactive({
    # use reactive dataframe as input for scale function from ingredients.R file
    df <- scale(wet_ingredients_df(), input$quantity, grams = T,#input$grams,
                ml = F)#input$ml)
    df$quantity <- format(df$quantity, drop0trailing = TRUE)
    df
  })
  # render the ingredients table
  output$dry_ingredients <- renderTable(scaled_dry(), 
                                    align = "rrl",
                                    include.rownames = FALSE,
                                    include.colnames = FALSE
                                    )
  # render the ingredients table
  output$wet_ingredients <- renderTable(scaled_wet(), 
                                        align = "rrl",
                                        include.rownames = FALSE,
                                        include.colnames = FALSE
  )
}

# Run the application (ALWAYS LAST LINE IN FILE)
shinyApp(ui = ui, server = server)

