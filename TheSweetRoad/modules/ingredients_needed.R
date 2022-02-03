## This will be for the first tab that shows you the options available

# metric module ----
ingredients_needed_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    # Output: A selector to show you which dessert type you selected
    # This will eventually either be deleted or modified ----
    verbatimTextOutput(ns("recipe_type_sel"), placeholder = TRUE),
    # The recipe table that can be toggled by the side panel choices (recipe type, etc.)
    dataTableOutput(ns('recipe_table')),
    tags$style(
      type = "text/css",
      
      ".shiny-output-error { visibility: hidden; }",
      
      ".shiny-output-error:before { visibility: hidden; }"
      
    ),
    # The table that outputs the ingredients to make the recipes
    dataTableOutput(ns("ingredients_table")),
    # The table that outputs the steps to make the recipes
    dataTableOutput(ns("steps_table"))
  )
}

ingredients_needed_server <-
  function(id, input, output, session, rec_options) {
    # Calling the moduleServer function
    moduleServer(# Setting the id
      id,
      # Defining the module core mechanism
      function(input, output, session) {
        ns <- session$ns
        
        # This code with be modified in the future it is currently here just to make sure the recipe
        # check boxes are linked up properly to the backend - pls fix
        output$recipe_type_sel <- renderText({
          recipe_type <- rec_options()$recipe_options
          
          paste0("You selected ", recipe_type)
        })
        
        # Creating the data table that will interact with the recipe side panel and allow users to
        # see which recipes match up with the selected user inputs
        dataset <- reactive({
          # Pulling in the user selections from the side panel module
          # Pulling in the recipe type (cake, cake pop, pie or tart, etc.)
          recipe_type_selected <- rec_options()$recipe_options
          # Pulling in the sweetness scale values (1-5)
          sweetie_scale <- rec_options()$sweet_scale
          # Pulling in the ingredients needed for the recipe (butter, etc.)
          ings_needed <-
            stringr::str_to_title(gsub("_", " ", rec_options()$ings))
          # Pulling in the name of the recipe submitter
          recipe_submitter_selected <-
            stringr::str_to_title(gsub("_", " ", rec_options()$ppl))
          # Pulling in how many servings the dessert makes
          servings_made <- rec_options()$servings_made
          
          # PCleaning up the names of our inputs
          recipe_name_data_filt <- ingredients_data %>%
            dplyr::mutate(
              recipe_submitter = stringr::str_to_title(gsub("_", " ", recipe_submitter)),
              ingredient = stringr::str_to_title(gsub("_", " ", ingredient)),
              recipe_name = stringr::str_to_title(gsub("_", " ", recipe_name))
            )
          
          # If the user did not select all recipe types and did not select all recipe
          # submitters, filter to the following options:
          if (recipe_type_selected != "all" &
              recipe_submitter_selected != "All") {
            # Rename the name
            recipe_name_data <- recipe_name_data_filt %>%
              # filter to the recipe type that was selected to match the recipe type
              # associated with the recipe that was submitted
              dplyr::filter(
                recipe_type %in% recipe_type_selected,
                ingredient  %in% ings_needed,
                recipe_submitter %in% recipe_submitter_selected
              ) %>%
              # Only select the unique identifiers for the recipes
              dplyr::select(recipe_submitter, recipe_name, recipe_type) %>%
              unique()
            # If the recipe type is not "All"
          } else if (recipe_type_selected != "all") {
            recipe_name_data <- recipe_name_data_filt %>%
              # filter to the recipe type associated with the recipe that was submitted
              dplyr::filter(recipe_type %in% recipe_type_selected,
                            ingredient  %in% ings_needed,) %>%
              # Only select the unique identifiers for the recipes
              dplyr::select(recipe_submitter, recipe_name, recipe_type) %>%
              unique()
            # If the recipe submitter option is not All
          } else if (recipe_submitter_selected != "All") {
            recipe_name_data <- recipe_name_data_filt   %>%
              # filter to the user inputs
              dplyr::filter(
                ingredient  %in% ings_needed,
                recipe_submitter %in% recipe_submitter_selected
              ) %>%
              # select only the unique identifiers
              dplyr::select(recipe_submitter, recipe_name, recipe_type) %>%
              unique()
            
          } else {
            # Or else only filter the ingredients
            recipe_name_data <- recipe_name_data_filt   %>%
              dplyr::filter(ingredient %in% ings_needed) %>%
              # select only the unique identifiers for the recipe
              dplyr::select(recipe_submitter, recipe_name, recipe_type) %>%
              unique()
          }
          recipe_name_data <- recipe_name_data %>%
            # Final data manipulation to make the recipe type legible
            dplyr::mutate(recipe_type = stringr::str_to_title(gsub("_", " ", recipe_type)))
          
          
        })
        ######################################### 1st DATA TABLE ##############################
        # Let's render the data table
        output$recipe_table <- DT::renderDataTable({
          # Pull in the data frame we just set conditions for above
          DT::datatable(
            dataset(),
            rownames = FALSE,
            colnames = c('Recipe Submitter', 'Recipe Name', 'Recipe Type'),
            options = list(
              searching = FALSE,
              dom = 't',
              ordering = F,
              initComplete = JS(
                "function(settings, json) {",
                "$(this.api().table().header()).css({'background-color': '#1aa3ff', 'color': '#000000'});",
                "}"
              )
            )
          )
        })
        ######################################### 2nd DATA TABLE ##############################
        # Let's render the data table
        output$ingredients_table <- DT::renderDataTable({
          # Selecting the rows that the user clicked on in the above dataframe
          selected <<- input$recipe_table_rows_selected
          # selecting the name of the recipe selected
          project <<-
            unique(dataset()[selected, c("recipe_name")])
          
          # Filtering to the ingredient needed for the recipe selected
          ingreds_needed <<- ingredients_data %>%
            dplyr::select(recipe_submitter, recipe_name, amount, ingredient) %>%
            dplyr::mutate(
              recipe_submitter = stringr::str_to_title(gsub("_", " ", recipe_submitter)),
              recipe_name = stringr::str_to_title(gsub("_", " ", recipe_name)),
              amount = stringr::str_to_title(gsub("_", " ", amount)),
              ingredient = stringr::str_to_title(gsub("_", " ", ingredient))
            )
          
          # Selecting all of the ingredients associated with the recipes that were submitted
          ingreds_needed <<-
            ingreds_needed[ingreds_needed$recipe_name %in% project, ]
          
          # Pull in the data and don't allow searching
          DT::datatable(
            ingreds_needed,
            extensions = 'Buttons',
            rownames = FALSE,
            colnames = c('Recipe Submitter', 'Recipe Name', 'Amount', 'Ingredient'),
            options = list(
              searching = FALSE,
              dom = 'Bfrtip',
              buttons =
                list(
                  'copy',
                  'print',
                  list(
                    extend = 'collection',
                    buttons = c('csv', 'excel', 'pdf'),
                    text = 'Download'
                  )
                ),
              initComplete = JS(
                "function(settings, json) {",
                "$(this.api().table().header()).css({'background-color': '#1aa3ff', 'color': '#000000'});",
                "}"
              )
            )
          )
          
          
        })
        
        ######################################### THIRD DATA TABLE ##############################
        # Render another dataframe that will read in all of the steps associated
        # with the recipes that were selected
        output$steps_table <- DT::renderDataTable({
          # Selecting the rows that the user clicked on in the above dataframe
          selected <- input$recipe_table_rows_selected
          # selecting the name of the recipe selected
          project <-
            unique(dataset()[selected, c("recipe_name")])
          # Filtering to the steps associated with the recipe selected
          steps_needed <- steps_data %>%
            dplyr::select(recipe_submitter,
                          recipe_name,
                          step_number,
                          recipe_step_details) %>%
            dplyr::mutate(
              recipe_submitter = stringr::str_to_title(gsub("_", " ", recipe_submitter)),
              recipe_name = stringr::str_to_title(gsub("_", " ", recipe_name)),
              step_number = stringr::str_to_title(gsub("_", " ", step_number)),
              recipe_step_details = stringr::str_to_title(gsub("_", " ", recipe_step_details))
            )
          
          # Selecting all of the steps associated with the recipes that were submitted
          steps_needed <-
            steps_needed[steps_needed$recipe_name %in% project, ]
          
          # Pull in the data and take out filtering ability
          DT::datatable(
            steps_needed,
            extensions = 'Buttons',
            rownames = FALSE,
            colnames = c(
              'Recipe Submitter',
              'Recipe Name',
              'Step Number',
              "Step Details"
            ),
            options = list(
              searching = FALSE,
              dom = 'Bfrtip',
              buttons =
                list(
                  'copy',
                  'print',
                  list(
                    extend = 'collection',
                    buttons = c('csv', 'excel', 'pdf'),
                    text = 'Download'
                  )
                ),
              initComplete = JS(
                "function(settings, json) {",
                "$(this.api().table().header()).css({'background-color': '#1aa3ff', 'color': '#000000'});",
                "}"
              )
            )
          )
          
        })
        
        
        
      })
  }