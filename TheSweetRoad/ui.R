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
  
  # tags$head(tags$style(HTML("
  #   .shiny-text-output {
  #     background-color:#fff;
  #   }
  #          #background-image: url('texturebg.png');
# font-family: 'Source Sans Pro';
#  color: #fff; 
  # "))),
  # setBackgroundColor(
  #   color = c("#F7FBFF", "#2171B5"),
  #   gradient = "linear",
  #   direction = "bottom"
  # ),
  
  h1("Digital", span("Sweet Road Recipe Generator", style = "font-weight: 300"), 
     style = "text-align: center;
         padding: 20px; color: #2171B5"),
  br(),
    # Application title ----

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
                helpText("Hi there! Ready to share a recipe? Follow the instructions to submit a new recipe.")
                  
                  # "Use this tab to submit new recipes.",
                  #        "1. Enter the recipe submitter's information",
                  #        "(your name, the recipe's name, the type of recipe",
                  #        "and how sweet you would say the recipe is on a scale of 1-5).",
                  #        "2. Submit the ingredients needed to make the recipe along with",
                  #        "the quantities associated with the ingredients.",
                  #        "3. Enter in the steps associated with creating the recipe.", 
                  #        "You can add a row by right clicking and inserting a new row.")
            )
        ),
            
            # recipe_options.R houses the function that creates all the UI elements in the baking app  ----

        # Adding the main tabs for the app ----
        mainPanel(
         # column(7,
          tabsetPanel(
            id = 'tabss',
            type = "tabs",
            # This tab will give the user the available recipes based on their specifications
            tabPanel("Recipe Options", ingredients_needed_ui("ingredients_needed.R")),
            # This tab will be where users can add their own recipes
            tabPanel("Submit a New Recipe", submit_new_recipe_ui("submit_new_recipe.R"))
        )))
))

