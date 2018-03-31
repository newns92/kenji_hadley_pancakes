dry <- data.frame(
  quantity = c(10, 1, 0.5, 1, 1),
  unit = c("oz", "tsp", "tsp", "tsp", "tbsp"),
  ingredient = c("All-Purpose Flour", "Baking Powder", "Baking Soda",
                 "Kosher Salt", "Sugar"),
  stringsAsFactors = FALSE
)

#head(dry)

buttermilk <- data.frame(
  quantity = c(2, 12, 8, 4, NA),
  unit = c("", "fl. oz", "oz", "tbsp", ""),
  ingredient = c("Large Eggs (Yolks seperated)", "Buttermilk", "Sour Cream",
                 "Unsalted Butter (with some more for serving)", "Warm Maple Syrup"),
  stringsAsFactors = FALSE
)

#head(wet)

yogurt <- data.frame(
  quantity = c(2, 8, 1.75, 8, 4, NA),
  unit = c("", "oz", "fl. oz", "oz", "tbsp", ""),
  ingredient = c("Large Eggs (Yolks seperated)", "Yogurt", "Milk", "Sour Cream",
                 "Unsalted Butter (with some more for serving)", "Warm Maple Syrup"),
  stringsAsFactors = FALSE
)

sourCream <- data.frame(
  quantity = c(2, 4, 12, 4, NA),
  unit = c("", "fl. oz", "oz", "tbsp", ""),
  ingredient = c("Large Eggs (Yolks seperated)", "Milk", "Sour Cream",
                 "Unsalted Butter (with some more for serving)", "Warm Maple Syrup"),
  stringsAsFactors = FALSE
)

cremeFraiche <- data.frame(
  quantity = c(2, 4, 4, 12, 4, NA),
  unit = c("", "fl. oz", "oz", "oz", "tbsp", ""),
  ingredient = c("Large Eggs (Yolks seperated)", "Milk", "Creme Fraiche", "Sour Cream",
                 "Unsalted Butter (with some more for serving)", "Warm Maple Syrup"),
  stringsAsFactors = FALSE
)

scale <- function(ingredients, quantity = 1, grams = T, ml = F) {
  
  cakes <- quantity * 4
  
  if (grams) {
    in_oz <- ingredients$unit == "oz"
    ingredients$quantity[in_oz] <- round(ingredients$quantity[in_oz] * 28.3495231)
    ingredients$unit[in_oz] <- "grams"
    if (ml) {
      in_floz <- ingredients$unit == "fl. oz"
      ingredients$quantity[in_floz] <- round(ingredients$quantity[in_floz] * 29.5735296)
      ingredients$unit[in_oz] <- "mL"    
    }
    #return 
    ingredients
  }
}
#
#print(scale(dry))

# units <- c(
#     "serving" = 10,
#     "oz" = 1,
#     "cup" = 8,
#     "quart" = 32,
#     "gallon" = 128
#   )
  
  #to_oz <- function(unit) {
  #  units[[unit]]
  #}
  #from_oz <- function(unit) {
  #  1 / units[[unit]]
#}
 # print(ingredients)
 # print(cakes)
#}