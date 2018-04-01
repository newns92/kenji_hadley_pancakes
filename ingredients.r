dry <- data.frame(
  quantity = c(10, 1, 0.5, 1, 1),
  unit = c("oz", "tsp", "tsp", "tsp", "tbsp"),
  ingredient = c("All-Purpose Flour", "Baking Powder", "Baking Soda",
                 "Kosher Salt", "Sugar"),
  stringsAsFactors = FALSE
)

#head(dry)

buttermilk <- data.frame(
  quantity = c(2, 12, 8, 4),
  unit = c("", "fl. oz", "oz", "tbsp"),
  ingredient = c("Large Eggs (yolks seperated)", "Buttermilk", "Sour Cream",
                 "Unsalted Butter"),
  stringsAsFactors = FALSE
)

#head(wet)

yogurt <- data.frame(
  quantity = c(2, 300/28.3495231, 5, 8, 4),
  unit = c("", "oz", "fl. oz", "oz", "tbsp"),
  ingredient = c("Large Eggs (yolks seperated)", "Yogurt", "Milk", "Sour Cream",
                 "Unsalted Butter"),
  stringsAsFactors = FALSE
)

sourCream <- data.frame(
  quantity = c(2, 4, 12, 4),
  unit = c("", "fl. oz", "oz", "tbsp"),
  ingredient = c("Large Eggs (yolks seperated)", "Milk", "Sour Cream",
                 "Unsalted Butter"),
  stringsAsFactors = FALSE
)

cremeFraiche <- data.frame(
  quantity = c(2, 4, 4, 12, 4),
  unit = c("", "fl. oz", "oz", "oz", "tbsp"),
  ingredient = c("Large Eggs (yolks seperated)", "Milk", "Creme Fraiche", "Sour Cream",
                 "Unsalted Butter"),
  stringsAsFactors = FALSE
)

scale <- function(ingredients, quantity = 1, grams = T, ml = F) {
  
  #cakes <- quantity * 4
  #by <- quantity * to_oz(unit) / 10
  ingredients$quantity <- ingredients$quantity * quantity

  if (grams) {
    in_oz <- ingredients$unit == "oz"
    ingredients$quantity[in_oz] <- round(ingredients$quantity[in_oz] * 28.3495231)
    ingredients$unit[in_oz] <- "grams"
  } else {
    in_oz <- ingredients$unit == "oz"
    ingredients$quantity[in_oz] <- round(ingredients$quantity[in_oz])
  }
  if (ml) {
    in_floz <- ingredients$unit == "fl. oz"
    ingredients$quantity[in_floz] <- round(ingredients$quantity[in_floz] * 29.5735296)
    ingredients$unit[in_floz] <- "mL"    
  }
 # if (cups) {
 #   in_oz <- ingredients$unit == "oz"
 #   ingredients$quantity[in_floz] <- round(ingredients$quantity[in_floz] * 29.5735296)
 #   ingredients$unit[in_floz] <- "cups"    
  #}
  #return 
  ingredients
}