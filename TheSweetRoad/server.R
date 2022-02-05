#' The server function is used to be able to connect all of our moving pieces in the codebase
#' together.
#'
#' @recipeSidePanelServer links the server portion of the code for the side panel of the app where
#' users can filter the recipes available to specify what they are looking for
#' @ingredientsServer links the server portion of the code for the Recipe Options tab
#' (ingredients_needed.R) so that users can select from the recipes available. This tab passes
#' in @rec_options which links the inputs a user puts in the @recipeSidePanelServer and allows
#' us to use those inputs in this tab
#' @submitNewRecipeServer links the server side code for where we submit a new recipe to our remote
#' database


# Loading in shiny library (also done in global script)
library(shiny)

# Define server logic required to draw a histogram
server <- shinyServer(function(input, output) {
  # Server side code to connect the side panel that contains the recipe option filters
  recipeSidePanelServer <-
    recipe_side_panel_server("recipe_side_panel")
  
  # Server side code for the Recipe Options tab in the app where users can see the recipes
  # available for them to pick from. This arguement passes rec_options which allows us to
  # use user inputs from the recipe side panel module (R script) into the Recipe Options
  # (ingredients_needed.R) script
  ingredientsServer <-
    ingredients_needed_server("ingredients_needed.R", rec_options = recipeSidePanelServer)
  
  # Server side code that allows users to submit a new recipe - we connect to our remote
  # SQL db here
  submitNewRecipeServer <-
    submit_new_recipe_server("submit_new_recipe.R")

})
