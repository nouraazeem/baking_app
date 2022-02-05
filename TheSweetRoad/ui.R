#' This is the overarching UI for the baking app. The point of this baking app is to host all of my recipes and for
#' me to be able to narrow down and be inspired by the art of the possible in terms of what I can make. This UI script
#' will load in all of the tabs and the recipe side panel.
#'
#'

library(shiny)

# Define UI for application that draws a histogram
ui <- shinyUI(fluidPage(
  # Header that shows the name of the app in a cool font
  h1(
    "Digital",
    span("Sweet Road Recipe Generator", style = "font-weight: 300"),
    style = "text-align: center;
         padding: 20px; color: #2171B5"
  ),
  br(),
  
  # Adding a side selection menu ----
  sidebarLayout(
    # Sidebar Panel for basic inputs such as which dessert you are picking, which ingredients do you currently have, etc. ----
    sidebarPanel(
      # Conditional panel means that when the user toggles between the two tabs they will see two seperate things in the 
      # conditional panel on the left hand side of the app
      conditionalPanel(condition = "input.tabss === 'Recipe Options'",
                       recipe_side_panel_ui("recipe_side_panel")),
      conditionalPanel(
        'input.tabss === "Submit a New Recipe"',
        helpText(
          "Hi there! Ready to share a recipe? Follow the instructions to submit a new recipe."
        )
      )
    ),
    
    # Adding the main tabs for the app ----
    mainPanel(
      tabsetPanel(
        id = 'tabss',
        type = "tabs",
        # This tab will give the user the available recipes based on their specifications
        tabPanel(
          "Recipe Options",
          ingredients_needed_ui("ingredients_needed.R")
        ),
        # This tab will be where users can add their own recipes
        tabPanel(
          "Submit a New Recipe",
          submit_new_recipe_ui("submit_new_recipe.R")
        )
      ))
  )
))
