# create dry ingredients data frame ####
dry <- data.frame(
  quantity = c(10, 1, 0.5, 1, 1),
  unit = c("oz", "tsp", "tsp", "tsp", "tbsp"),
  ingredient = c("All-Purpose Flour", "Baking Powder", "Baking Soda",
                 "Kosher Salt", "Sugar"),
  stringsAsFactors = FALSE
)

## WET ingredient options ####
buttermilk <- data.frame(
  quantity = c(2, 12, 8, 4),
  unit = c("", "fl. oz", "oz", "tbsp"),
  ingredient = c("Large Eggs (yolks seperated)", "Buttermilk", "Sour Cream",
                 "Unsalted Butter, melted"),
  stringsAsFactors = FALSE
)

yogurt <- data.frame(
  quantity = c(2, round(300 / 28), 5, 8, 4),
  unit = c("", "oz", "fl. oz", "oz", "tbsp"),
  ingredient = c("Large Eggs (yolks seperated)", "Yogurt", "Milk", "Sour Cream",
                 "Unsalted Butter, melted"),
  stringsAsFactors = FALSE
)

sourCream <- data.frame(
  quantity = c(2, 4, 12, 4),
  unit = c("", "fl. oz", "oz", "tbsp"),
  ingredient = c("Large Eggs (yolks seperated)", "Milk", "Sour Cream",
                 "Unsalted Butter, melted"),
  stringsAsFactors = FALSE
)

cremeFraiche <- data.frame(
  quantity = c(2, 6, 6, 8, 4),
  unit = c("", "fl. oz", "oz", "oz", "tbsp"),
  ingredient = c("Large Eggs (yolks seperated)", "Milk", "Creme Fraiche",
                 "Sour Cream", "Unsalted Butter, melted"),
  stringsAsFactors = FALSE
)

## Function to scale ingredients based on number of batches selected
##  by user and measurement options for volume and weight ####
scale_ingredients <- function(ingredients, quantity = 1,
                              fluid_unit = "fl. oz", weight_v_vol = "Grams") {

  # increase quantity based on user selections of batches
  ingredients$quantity <- ingredients$quantity * quantity

  # update ingredients baed on radiobuttons
  if (weight_v_vol == "Grams/Tbsp") {
    # get those ingredients currently in oz and get butter
    in_oz <- ingredients$unit == "oz"
    butter <- ingredients$ingredient == "Unsalted Butter, melted"
    # convert from ounces and tbsp (just for butter) to grams
    ingredients$quantity[in_oz] <- round(ingredients$quantity[in_oz] * 28.3495231)
    ingredients$quantity[butter] <- round(ingredients$quantity[butter] * 14)
    # reset units from oz to grams
    ingredients$unit[in_oz] <- "grams"
    ingredients$unit[butter] <- "grams"
  }
  else if (weight_v_vol == "Cups") {
    # get the 2 ingredients currently in cups (flour, sour cream) and convert
    # to cups specified by recipe
    flr <- ingredients$ingredient == "All-Purpose Flour"
    sc <- ingredients$ingredient == "Sour Cream"
    yog <- ingredients$ingredient == "Yogurt"
    cf <- ingredients$ingredient == "Creme Fraiche"

    ingredients$quantity[flr] <- round(ingredients$quantity[flr] / 5, 1)
    ingredients$quantity[sc] <- round(ingredients$quantity[sc] / 8, 1)
    ingredients$quantity[yog] <- round(ingredients$quantity[yog] / 8.64, 1)
    ingredients$quantity[cf] <- round(ingredients$quantity[cf] / 8.46575, 1)

    # change units for flour and sour cream to cups
    ingredients$unit[flr] <- "cups"
    ingredients$unit[sc] <- "cups"
    ingredients$unit[yog] <- "cups"
    ingredients$unit[cf] <- "cups"
  }
  else {
    # make units round number
    in_oz <- ingredients$unit == "oz"
    ingredients$quantity[in_oz] <- round(ingredients$quantity[in_oz])
  }

  if (fluid_unit == "mL") {
    # convert from fl. oz to mL if checked, change 'units' text
    in_floz <- ingredients$unit == "fl. oz"
    ingredients$quantity[in_floz] <- round(ingredients$quantity[in_floz] * 29.5735296)
    ingredients$unit[in_floz] <- "mL"
  }
  # convert from fl. oz to cups if checked, change 'units' text
  else if (fluid_unit == "Cups") {
        in_floz <- ingredients$unit == "fl. oz"
        ingredients$quantity[in_floz] <- round(ingredients$quantity[in_floz] / 8, 1)
        ingredients$unit[in_floz] <- "cups"
  }

  ingredients
}