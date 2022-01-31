#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  # Server side code to connect the side panel that contains the recipe option filters
  recipeSidePanelServer <-
    recipe_side_panel_server("recipe_side_panel.R")
  
  # Server side code to use the user selected options to see the available recipes
  # ingredientsServer <-
  #   ingredients_needed_server("ingredients_needed.R")
  # 
  # recipe_options <- callModule(recipe_side_panel_server, recipe_options$recipe_options)
  
  ingredientsServer1 <- callModule(ingredients_needed_server, "ingredients_needed.R")
  
 # browser()
  # Server side code that allows users to submit a new recipe
  submitNewRecipeServer <-
    submit_new_recipe_server("submit_new_recipe.R")
  
  # Recipe Database ----
  
  
})
