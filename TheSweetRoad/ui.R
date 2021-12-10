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
    
    # Adding a side selection menu ----
    sidebarLayout(
        
        # Sidebar Panel for basic inputs such as which dessert you are picking, which ingredients do you currently have, etc. ----
        sidebarPanel(
            
            # Input: Check box options for selecting the dessert recipes you would like to see ----
            checkboxGroupInput(
                "recipe_options",
                label = h3("Recipe Type"),
                c(
                    "Cake" = "cake",
                    "Cake Pop" = "cake_pop",
                    "Cheesecake" = "cheesecake",
                    "Cookie" = "cookie",
                    "Pie/Tart" = "pie_tart",
                    "Traditional Middle Eastern Dessert" = "mideast_dessert"
                ),
                selected = "cake"
            ),
            
            # Input: Slider for how sweet the dessert should be ----
            sliderInput(
                "sweet_scale",
                "How sweet do you want the dessert to be? (Scale 1 - Noura)",
                value = 5,
                min = 1,
                max = 10
            ),
            
            # Input: Multi-select for which ingredients you already have ----
            selectizeInput(
                'ings', 'Which ingredients do you currently have?', choices = c(
                    "Butter", 
                    "Cardamom",
                    "Cinnamon",
                    "Cream Cheese",
                    "Eggs",
                    "Flour", 
                    "Milk",
                    "Mozzarella Cheese",
                    "Puff Pastry",
                    "Ricotta Cheese"
                ), multiple = TRUE
            ),
            
            # Input: Multiselect for who created the recipe ----
            selectizeInput(
                'ppl', 'Whose recipes do you want to look at?', choices = c(
                    "Noura",
                    "Uhh Noura-- duh",
                    "Hmm -- Noura??",
                    "Just the best - so Noura?"
                ), multiple = TRUE
            ),
            
            # Input: Slider Range for how long you want spend on your dessert in minutes----
            sliderInput("time_slider", label = h5("How much time do you have to make this dessert? (in minutes)"), min = 0,
                        max = 160, value = c(48, 112)),
            
            # Output: A selector to show you which dessert type you selected
            # This will eventually either be deleted or modified ----
            verbatimTextOutput("recipe_type", placeholder = TRUE)
        ),
        
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

