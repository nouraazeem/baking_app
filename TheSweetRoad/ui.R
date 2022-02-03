#
#
#   This is the UI code for The Sweet Road Baking Web App. This script
# will contain all of the UI elements needed to create the web app.
# The aforementioned needed UI elements are as follow:
# 1. noura pls fix and come back and add proper roxygen ok?
#
#
#
#

library(shiny)

# Define UI for application that draws a histogram
ui <- shinyUI(fluidPage(
    
      header <- dashboardHeader(title = "Sweet Road goes digital"),
    # Application title ----
    titlePanel("The Sweet Road... goes digital"),
    
    # # Adding a button for users to add their own recipe ----
    # actionButton("add_new_recipe", "Add New Recipe", style = "simple", size = "sm", color = "warning"),
    
    # Adding a side selection menu ----
    sidebarLayout(
        
        # Sidebar Panel for basic inputs such as which dessert you are picking, which ingredients do you currently have, etc. ----
        sidebarPanel(
            
            conditionalPanel(
                condition = "input.tabss === 'Recipe Options'",
                recipe_side_panel_ui("recipe_side_panel")
            ),
            conditionalPanel(
                'input.tabss === "Submit a New Recipe"',
                helpText("Enter recipe submitter's information, ingredients, and steps in the corresponding boxes.")
            )
            ),
            
            # recipe_options.R houses the function that creates all the UI elements in the baking app  ----

        # Adding the main tabs for the app ----
        mainPanel(tabsetPanel(
            id = 'tabss',
            type = "tabs",
            # This tab will give the user the available recipes based on their specifications
            tabPanel("Recipe Options", ingredients_needed_ui("ingredients_needed.R")),
            # This tab will be where users can add their own recipes
            tabPanel("Submit a New Recipe", submit_new_recipe_ui("submit_new_recipe.R"))
            
        ))
    )
    
))

