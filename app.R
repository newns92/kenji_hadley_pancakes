library(shiny)
library(utils)
cf <- enc2utf8(as("Crème fraîche", "character")) # used to add accents for creme fraiche
# Define UI for application
ui <- fluidPage(
  # theme
  theme = shinythemes::shinytheme("sandstone"),
 
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
                        ,label = "How many batches?"
                        ,value = 1  # default value
                        ,min = 1),
           
           p("(1 batch makes sixteen 6-inch pancakes)"),
           
           
           selectInput(inputId = "wet_base"
                       ,label = "Substitutions if no buttermilk"
                       ,choices = c("None", "Sour Cream", "Yogurt", cf)
                       ,selected = "None"),
           
           checkboxInput("cup", "Use cups instead of weight?", F),
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
             tags$li("Combine flour, baking powder, baking soda, salt, and sugar in a large bowl and whisk until 
                     homogenous (If using later, transfer to an airtight container, as mix will stay good for
                     3 months)."),
             tags$li("In a medium clean bowl, whisk egg whites until stiff peaks form."),
             tags$li("In a large bowl, whisk egg yolks, buttermilk (or buttermilk substitute ingredients), and sour
                      cream until homogenous."),
             tags$li("Slowly drizzle in the melted butter while still whisking."),
             tags$li("Carefully fold in the egg whites with a rubber spatula until just combined."),
             tags$li("Pour the wet mixture over the dry mix and fold until just combined (leave plenty of lumps)."),
             tags$li("Heat a large, heavy-bottomed nonstick skillet over medium heat for 5 minutes (or use an 
                     electric griddle), adding a small amount of butter or oil and spreading with a paper towel 
                     until no visible butter or oil remains."),
             tags$li("Pour a 1/4-cup measurements of the batter into the skillet and cook until bubbles start to
                     appear on top, and the bottoms are golden brown (about 2 minutes)."),
             tags$li("Carefully flip the pancakes and cook on the second side until golden brown and completely 
                     set (about 2 minutes longer)."),
             tags$li("Serve pancakes immediately with warm maple syrup and butter, or keep warm on a wire rack set on a rimmed baking sheet in a warm
                     oven while you cook the remaining pancakes.")
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
    else if (input$wet_base == cf) cremeFraiche
    else buttermilk
  )
  
  scaled_dry <- reactive({
    # use reactive dataframe as input for scale function from ingredients.R file
    df <- scale(dry_ingredients_df(), input$quantity, input$grams,
                input$ml)
    df$quantity <- format(df$quantity, drop0trailing = TRUE)
    df
  })
  scaled_wet <- reactive({
    # use reactive dataframe as input for scale function from ingredients.R file
    df <- scale(wet_ingredients_df(), input$quantity, input$grams,
                input$ml)
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

