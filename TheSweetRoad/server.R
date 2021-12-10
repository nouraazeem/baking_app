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

})
