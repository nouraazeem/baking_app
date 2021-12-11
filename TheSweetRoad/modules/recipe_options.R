## This will be for the first tab that hsows you the options available

# metric module ----
recipe_options_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
  
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
  
  
  
  )
}

recipe_options_server <- function(input, output, session) {
  # Calling the moduleServer function
  # moduleServer(
  #   # Setting the id
  #   id,
  #   # Defining the module core mechanism
  #   function(input, output, session) {
  #     # This code with be modified in the future it is currently here just to make sure the recipe 
  #     # check boxes are linked up properly to the backend - pls fix
  #     # output$recipe_type <- renderText({
  #     #   recipe_options <- paste(input$recipe_options, "yum!")
  #     #   paste("You selected ", recipe_options)
  #     # })
  #   })
  
  
}