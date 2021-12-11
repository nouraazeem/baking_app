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
shinyUI(fluidPage(
    # Application title ----
    titlePanel("The Sweet Road... goes digital"),
    
    # Adding a button for users to add their own recipe ----
    actionButton("add_new_recipe", "Add New Recipe", style = "simple", size = "sm", color = "warning"),
    
    # Adding a side selection menu ----
    sidebarLayout(
        
        # Sidebar Panel for basic inputs such as which dessert you are picking, which ingredients do you currently have, etc. ----
        sidebarPanel(
            
            # recipe_options.R houses the function that creates all the UI elements in the baking app  ----
            recipe_options_ui("recipe_options.R")),
        
        # Adding the main tabs for the app ----
        mainPanel(tabsetPanel(
            type = "tabs",
            # This tab will give the user the available recipes based on their specifications
            tabPanel("Recipe Options"),
            # This tab will tell the user the actual recipe as well as the ingredients needed
            tabPanel("Recipe + Ingredients Needed"),
            # This tab will tell the user the story behind the recipe if one was inputted
            tabPanel("Story Behind Recipe")
        ))
    )
    
))

