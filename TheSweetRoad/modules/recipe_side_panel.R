## This will be for the first tab that shows you the options available

# metric module ----
recipe_side_panel_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
  
  # Input: Check box options for selecting the dessert recipes you would like to see ----
  checkboxGroupInput(
   
    ns("recipe_options"),
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
    ns("sweet_scale"),
    "How sweet do you want the dessert to be? (Scale 1 - Noura)",
    value = 5,
    min = 1,
    max = 10
  ),
  
  # Input: Multi-select for which ingredients you already have ----
  selectizeInput(
    ns('ings'), 'Which ingredients do you currently have?', choices = c(
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
    ns('ppl'), 'Whose recipes do you want to look at?', choices = c(
      "Noura",
      "Uhh Noura-- duh",
      "Hmm -- Noura??",
      "Just the best - so Noura?"
    ), multiple = TRUE
  ),
  
  # Input: Slider Range for how many servings does  ----
  sliderInput(ns("servings_made"), label = h5("How many servings of dessert does this make?"), min = 0,
              max = 5, value = 2),
  
  # Output: A selector to show you which dessert type you selected
  # This will eventually either be deleted or modified ----
  verbatimTextOutput(ns("recipe_type"), placeholder = TRUE)
  
  
  
  )
}

recipe_side_panel_server <- function(id, input, output, session) {
  # Calling the moduleServer function
  moduleServer(
    # Setting the id
    id,
    # Defining the module core mechanism
    function(input, output, session) {
      
      ns <- session$ns
      
      # This code with be modified in the future it is currently here just to make sure the recipe
      # check boxes are linked up properly to the backend - pls fix
      recipe_option_select <- reactive(
       recipe <- input$recipe_options
      )
      
      output$recipe_type <- renderText({
       
        req(recipe_option_select())
        selected <- recipe_option_select()
        recipe_options_selected <- paste(input$recipe_options, "yum!")
        paste("You selected ", recipe_options_selected)
        #browser()
        
      })
     
      return(rec_opt = recipe_option_select)
    
    })

  
}