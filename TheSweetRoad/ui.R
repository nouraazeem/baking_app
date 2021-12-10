#
#
#   This is the UI code for The Sweet Road Baking Web App. This script
# will contain all of the UI elements needed to create the web app.
# The aforementioned needed UI elements are as follow:
# 1.
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
        
        # Sidebar Panel for inputs ----
        sidebarPanel(
            
            # Check box options for desserts ----
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
            
            # Input: Slider Range for how long you want spend on your dessert ----
            sliderInput("time_slider", label = h5("How much time do you have for this dessert?"), min = 0,
                        max = 160, value = c(48, 112)),
            
            # Output: A selector to show you which dessert type you selected
            verbatimTextOutput("recipe_type", placeholder = TRUE)
        ),
        
        # Adding the main tabs for the app ---
        mainPanel(tabsetPanel(
            type = "tabs",
            # This tab will give the user the option to pick what kind of recipe they want to look for
            tabPanel("Recipe Options"),
            tabPanel("Recipe + Ingredients Needed"),
            tabPanel("Story Behind Recipe")
        ))
    )
))

# # Sidebar layout with recipe options (how sweet, ingredients, etc.) ----
# sidebarLayout(
#
#
# #     ,
# #
# #     # Adding a break to introduce some spacing to the side tab ----
# #     br(),
# #
# # ))
