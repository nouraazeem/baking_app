## This will be for the first tab that shows you the options available

# metric module ----
ingredients_needed_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    
    # Output: A selector to show you which dessert type you selected
    # This will eventually either be deleted or modified ----
    verbatimTextOutput(ns("recipe_type_sel"), placeholder = TRUE)
    
    
    
  )
}

ingredients_needed_server <- function(id, input, output, session, rec_options) {
  # Calling the moduleServer function
  moduleServer(
    # Setting the id
    id,
    # Defining the module core mechanism
    function(input, output, session) {
      
      ns <- session$ns
      
      #recipe_options <- 
      # This code with be modified in the future it is currently here just to make sure the recipe
      # check boxes are linked up properly to the backend - pls fix
      output$recipe_type_sel <- renderText({

        recipe_type <- rec_options()

        paste0("You selected ", recipe_type)
      })
    })
  
  
}