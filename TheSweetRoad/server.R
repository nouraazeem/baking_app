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

    # This code with be modified in the future it is currently here just to make sure the recipe 
    # check boxes are linked up properly to the backend - pls fix
    output$recipe_type <- renderText({
        recipe_options <- paste(input$recipe_options, "yum!")
        paste("You selected ", recipe_options)
    })
    
    l <- reactiveValues()
    # When you click add a new recipe button this will be what it asks u ----
    observeEvent(input$add_new_recipe, {
        
        # Display the modal box with options 
        showModal(modalDialog(
            tags$h2('Please enter your recipe'),
            textInput('name_of_submitted', "What is your name?"),
            textInput('recipe_name_submitted', "What is your recipe's name?"),
            textInput('ingred_submitted', "What ingredients are in your recipe? (Seperate w/ comma)"),
            textInput('steps_submitted', "What are the steps of your recipe? (Seperate w/ 1. 2. 3."),
            footer = tagList(
                actionButton('submit_recipe', "Submit New Recipe"),
                modalButton('cancel')
            )
            
        )
        )
        
        # Only store the information if the user clicks submit
        observeEvent(input$submit_recipe, {
            removeModal()
            l$name <- input$name
            l$state <- input$state
           
        })
    })
    
    recipeOptionsServer <- recipe_options_server("recipe_options.R")

    submitNewRecipeServer <- submit_new_recipe_server("submit_new_recipe.R")
    
    # Recipe Database ----
    

})
