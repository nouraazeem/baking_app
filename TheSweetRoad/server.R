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
server <- shinyServer(function(input, output) {
  # Server side code to connect the side panel that contains the recipe option filters
  recipeSidePanelServer <-
    recipe_side_panel_server("recipe_side_panel")
  
  # # execute recipe side selection optons modules
  #rec_options <- callModule(recipe_side_panel_server, "recipe_side_panel")
  
  # execute recipe options/ ingredients needed module
  # ingreds_neededServer <- callModule(ingredients_needed_server,
  #                                    "ingredients_needed.R",
  #                                    rec_options = rec_options)
  # 
# recipe_options <- callModule(ingredients_needed_server, "recipe_side_panel", options)
#
ingredientsServer <-
  ingredients_needed_server("ingredients_needed.R", rec_options= recipeSidePanelServer)

# browser()
# Server side code that allows users to submit a new recipe
submitNewRecipeServer <-
  submit_new_recipe_server("submit_new_recipe.R")

# Recipe Database ----


})
