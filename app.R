## Libraries ####
library(shiny)
library(utils)

# add accents for creme fraiche
#cf <- enc2utf8(as("Crème fraîche", "character")) 

# Define UI for application ####
ui <- fluidPage(
  # theme
  theme = shinythemes::shinytheme("sandstone"),

  # application title
  (title = titlePanel("The Best Light and Fluffy Buttermilk Pancakes")),

  # Sidebar layout with a input and output definitions
  sidebarLayout(
    sidebarPanel(width = 3,
      p(a("Recipe ",
          href = "https://www.seriouseats.com/recipes/2010/06/light-and-fluffy-pancakes-recipe.html"),
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
        a(img(src = "https://www.rstudio.com/wp-content/uploads/2014/04/shiny.png"
              ,height = "30px"),
          href = "https://www.r-project.org/"),
        "by",
        a(img(src = "https://www.rstudio.com/wp-content/uploads/2014/07/RStudio-Logo-Blue-Gray.png"
              ,height = "30px"),
          href = "http://shiny.rstudio.com"),
        "."),

      numericInput(inputId =  "quantity"
          ,label = "How many batches?"
          ,value = 1  # default value
          ,min = .5
          ,step = .5),
      p(tags$i("(1 batch makes sixteen 6-inch pancakes)")),
      p(tags$i("(Or eight, foot-long pancakes, you animal)")),

      selectInput(inputId = "wet_base"
          ,label="Substitutions if not using buttermilk"
          ,choices=c("None" = "none", "Sour Cream" = "sc"
                     ,"Yogurt" = "yogurt", "Creme Fraiche" = "cf")
          ,selected="None"),

      radioButtons(inputId="fluid_unit"
          ,label="Fluid Volume Measurement",
          choices=c("Cups","Fl. oz","mL")),
      radioButtons(inputId="weight_v_vol"
          ,label="Weight or Volume"
          ,choices=c("Cups","Oz.","Grams/Tbsp")),

      p(a("Source code", href = "https://github.com/newns92/kenji_hadley_pancakes")),
      
      p(a("Find", href = "http://stevenewns.netlify.com/"),
        a("me", href = "https://twitter.com/s_newns92/"),
        a("here.", href = "https://www.linkedin.com/in/stephen-newns/"))
    ),

    # output space layout
    mainPanel(width=9,
      # table 1
      fluidRow(column(width = 3,
             h3("Dry Ingredients"),
             tableOutput(outputId = "dry_ingredients")),
      # space between tables
      column(width = 1),
      # table 2
      column(width = 4,
             h3("Wet Ingredients"),
             tableOutput(outputId = "wet_ingredients"))),
      # instructions section
      fluidRow(h2("Instructions"),
        tags$ol(
          tags$li("Combine flour, baking powder, baking soda, salt, and sugar in a 
                    large bowl and whisk until homogenous (Mix will stay good for 3
                    months in an airtight container).")
          ,tags$li("In a clean medium bowl, whisk egg whites until",
                    tags$a(href="https://www.thekitchn.com/a-visual-guide-soft-peaks-firm-115557", "stiff peaks form."))
          ,tags$li("In a large bowl, whisk egg yolks, buttermilk (or buttermilk 
                    substitute ingredients), and sour cream until homogenous.")
          ,tags$li("Slowly drizzle the melted butter into the wet mixture while continuing to whisk.")
          ,tags$li("Carefully ",tags$a(href="https://www.thekitchn.com/how-to-fold-egg-whites-or-whipped-cream-into-a-batter-cooking-lessons-from-the-kitchn-48281","fold the egg whites "),
                    "into the wet mixture with a rubber spatula until just combined.")
          ,tags$li("Pour the wet mixture over the dry mix and fold until just 
                    combined (leave plenty of lumps).")
          ,tags$li("Heat a large nonstick skillet or electric griddle over medium heat for 
                    about 5 minutes, adding a small amount of butter or oil and spreading with
                    a paper towel until no visible butter or oil remains.")
          ,tags$li("Pour a 1/4-cup measurement of the batter into the skillet and cook 
                    until bubbles start to appear on top, and the bottoms are golden 
                    brown (about 2 minutes).")
          ,tags$li("Carefully flip the pancakes and cook on the second side until golden 
                    brown and completely set (about 2 minutes longer).")
          ,tags$li("Serve pancakes immediately with warm maple syrup and butter, or keep 
                    warm on a wire rack set on a rimmed baking sheet in a warm oven while 
                    you cook the remaining pancakes.")
        )
      )
    )
  )
)

# Define server logic ####
server <- function(input, output) {
  # load in data frames of ingredients and scale_ingredients() function
  source("./ingredients.r")

  # create reactive data frames based on which type of ingredients are chosen ####
  dry_ingredients_df <- reactive(
    dry
  )
  wet_ingredients_df <- reactive(
    if (input$wet_base == "sc") sourCream
    else if (input$wet_base == "yogurt") yogurt
    else if (input$wet_base == "cf") cremeFraiche
    else buttermilk
  )

# use reactive dataframe as input for scale_ingredients function from ingredients.R file ####
  scaled_dry <- reactive({
    df <- scale_ingredients(dry_ingredients_df(), input$quantity
                            ,input$fluid_unit, input$weight_v_vol)
    df$quantity <- format(df$quantity, drop0trailing = TRUE)
    df
  })
  scaled_wet <- reactive({
    df <- scale_ingredients(wet_ingredients_df(), input$quantity
                            ,input$fluid_unit, input$weight_v_vol)
    df$quantity <- format(df$quantity, drop0trailing = TRUE)
    df
  })

  # render dry and wet ingredients tables
  output$dry_ingredients <- renderTable(scaled_dry(), align = "rrl"
                                        ,include.rownames = FALSE
                                        ,include.colnames = FALSE)
  # render the ingredients table
  output$wet_ingredients <- renderTable(scaled_wet(), align = "rrl"
                                        ,include.rownames = FALSE
                                        ,include.colnames = FALSE
  )
}

# Run the application
shinyApp(ui = ui, server = server)