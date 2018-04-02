## Libraries ####
library(shiny)
library(utils)
cf <- enc2utf8(as("Crème fraîche", "character")) # used to add accents for creme fraiche

# Define UI for application ####
ui <- fluidPage(
  # theme
  theme = shinythemes::shinytheme("sandstone"),
 
  # application title
  titlePanel("The Best Light and Fluffy Buttermilk Pancakes"),
  
  # Sidebar layout with a input and output definitions
  sidebarLayout(# Inputs
    sidebarPanel(width = 3,
      p(a("Recipe ", 
          href = "https://www.seriouseats.com/2015/05/the-food-lab-how-to-make-the-best-buttermilk-pancakes.html"), 
        "from ",
        a("J. Kenji López-Alt", 
          href = "https://twitter.com/kenjilopezalt"), 
        "."), 
      p("Application inspired by",
        a("eggnogr",
          href = "https://hadley.shinyapps.io/eggnogr/"), 
        ", developed ", 
        a("Hadley Wickham",
          href = "https://twitter.com/hadleywickham"), 
        ", using ",
        a(img(src = "https://www.rstudio.com/wp-content/uploads/2014/04/shiny.png", height = "30px"),
          href = "https://www.r-project.org/"),
        "by",
        a(img(src = "https://www.rstudio.com/wp-content/uploads/2014/07/RStudio-Logo-Blue-Gray.png", height = "30px"),
          href = "http://shiny.rstudio.com"),
        "."),
      
      numericInput(inputId =  "quantity" 
          ,label = "How many batches?"
          ,value = 1  # default value
          ,min = 1),
      p(tags$i("(1 batch makes sixteen 6-inch pancakes)")),
      
      selectInput(inputId = "wet_base"
          ,label = "Substitutions if not using buttermilk"
          ,choices = c("None", "Sour Cream", "Yogurt", cf)
          ,selected = "None"),
      
      radioButtons(inputId="fluid_unit"
          ,label="Fluid Measurement",
          choices=c("Cups","Fl. oz","mL")),
      radioButtons(inputId="weight_v_vol"
          ,label="Weight or volume"
          ,choices=c("Cups","Oz.","Grams")),
             
      p(a("Source code", href = "https://github.com/newns92/kenji_hadley_pancakes"))
    ),
    
    mainPanel(width=9,
      fluidRow(column(width = 3,
             h3("Dry Ingredients"),
             tableOutput(outputId = "dry_ingredients")), 
      column(width = 1),
      column(width = 4,
             h3("Wet Ingredients"),
             tableOutput(outputId = "wet_ingredients"))),
      fluidRow(h2("Instructions"),
        tags$ol(
          tags$li("Combine flour, baking powder, baking soda, salt, and sugar in a large bowl and whisk until homogenous
                    (Mix will stay good for 3 months in an airtight container).")
          ,tags$li("In a clean medium bowl, whisk egg whites until stiff peaks form.")
          ,tags$li("In a large bowl, whisk egg yolks, buttermilk (or buttermilk substitute ingredients), 
                   and sour cream until homogenous.")
          ,tags$li("Slowly drizzle in the melted butter while still whisking.")
          ,tags$li("Carefully fold in the egg whites with a rubber spatula until just combined.")
          ,tags$li("Pour the wet mixture over the dry mix and fold until just combined (leave plenty of lumps).")
          ,tags$li("Heat a large nonstick skillet or electric griddle over medium for 5 minutes, adding a small 
                    amount of butter or oil and spreading with a paper towel until no visible butter or oil remains.")
          ,tags$li("Pour a 1/4-cup measurement of the batter into the skillet and cook until bubbles start to appear on top,
                    and the bottoms are golden brown (about 2 minutes).")
          ,tags$li("Carefully flip the pancakes and cook on the second side until golden brown and completely 
                    set (about 2 minutes longer).")
          ,tags$li("Serve pancakes immediately with warm maple syrup and butter, or keep warm on a wire rack set on a rimmed 
                    baking sheet in a warm oven while you cook the remaining pancakes.")
        )
      )
    )
  )
)

# Define server logic ####
server <- function(input, output) {
  # load in data frames of ingredients and scale() function
  source("./ingredients.r")
  
  # create reactive data frame based on which type of ingredients are chosen ####
  dry_ingredients_df <- reactive(
    dry
  )
  wet_ingredients_df <- reactive(
    if (input$wet_base == "Sour Cream") sourCream 
    else if (input$wet_base == "Yogurt") yogurt
    else if (input$wet_base == cf) cremeFraiche
    else buttermilk
  )
  
  scaled_dry <- reactive({
    # use reactive dataframe as input for scale function from ingredients.R file
    df <- scale(dry_ingredients_df(), input$quantity, input$fluid_unit, input$weight_v_vol)
    df$quantity <- format(df$quantity, drop0trailing = TRUE)
    df
  })
  scaled_wet <- reactive({
    df <- scale(wet_ingredients_df(), input$quantity, input$fluid_unit, input$weight_v_vol)
    df$quantity <- format(df$quantity, drop0trailing = TRUE)
    df
  })
  
  # render dry and wet ingredients tables
  output$dry_ingredients <- renderTable(scaled_dry(), align = "rrl", include.rownames = FALSE, include.colnames = FALSE)
  # render the ingredients table
  output$wet_ingredients <- renderTable(scaled_wet(), align = "rrl", include.rownames = FALSE, include.colnames = FALSE
  )
  
  # Display data table tab only if show_data is checked
    observeEvent(input$show_data, { # if show_data is checked
    if(input$show_data){
      showTab(inputId = "tabspanel", target = "Data", select = TRUE)
    } else {
      hideTab(inputId = "tabspanel", target = "Data")
    }
  })
}

# Run the application (ALWAYS LAST LINE IN FILE)
shinyApp(ui = ui, server = server)

