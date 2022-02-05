#' The Recipe Side Panel script is used to narrow down from the available recipes in the database and select
#' the recipes that match what you are looking for. We create user inputs that are passed to other modules 
#' so that we can narrow down the recipe options. That is for another script though.... (ingredients_needed.R)
#' This one focuses on creating user inputs
#' 
#'
#' @recipe_options checkbox input that allows users to select which recipe types they are looking at (cake, cake pop,
#' cheesecake, etc.)
#' @sweet_scale slider scale that allows users to decide the minimum level of sweetness the user would (if they select
#' 4 it means they want desserts a 4 or below in sweetness)
#' @ings allows you to narrow down based on what ingredients you already have in your kitchen. This list can be updated
#' at any point and won't have any implications downstream
#' @ppl multi select that allows the user to select whose recipes they would like to pick from. This will filter down from 
#' the recipes we have already in the database
#' @steps_table this table is loaded from the db and will pull out the recipe's info to make the recipe
#' (recipe_name, recipe_submitter, step_number, recipe_step_details, current_date_bake, recipe_type)
#' @recipe_submitter_names this is the recipe submitter's information for each recipe and does some basic data
#' cleaning to ensure that data matches formats throughout the app

# metric module ----
recipe_side_panel_ui <- function(id) {
  ns <- NS(id)
  
  tagList(

  # Input: Check box options for selecting the dessert recipes you would like to see ----
  checkboxGroupInput(
   
    ns("recipe_options"),
    label = h3("Recipe Type"),
    c(
      "All" = "all",
      "Cake" = "cake",
      "Cake Pop" = "cake_pop",
      "Cheesecake" = "cheesecake",
      "Cookie" = "cookie",
      "Other" = "other",
      "Pie or Tart" = "pie_tart",
      "Traditional Middle Eastern Dessert" = "traditional_middle_eastern_dessert"
    ),
    selected = "all"
  ),
  # Slider input allows users to slide through and decide the minimum level of sweetness the user would
  # like to select from (Oh, I want deserts that are a 4 or below)
  sliderInput(
    ns("sweet_scale"),
    "How sweet do you want the dessert to be? (Scale 1 - Noura)",
    value = 2.5,
    min = 1,
    max = 5
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
    ), multiple = TRUE, selected = "Butter"
  ),
  
  # Input: Multiselect for who created the recipe ----
  selectizeInput(
    ns('ppl'), 'Whose recipes do you want to look at?', 
    choices = recipe_submitter_names,
    multiple = TRUE, selected = "All"
  )
  
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
      
      # Here we are returning all the user inputs so we can reference them in other modules
      return(
       ingreds_sel = reactive({input}))
    
    })

  
}