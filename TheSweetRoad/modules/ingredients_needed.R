## This will be for the first tab that shows you the options available

# metric module ----
ingredients_needed_ui <- function(id) {
  ns <- NS(id)
  
  tagList(fluidRow(
    column(
      7,  #style='margin-bottom:30px;border:1px solid; padding: 10px;',
      #style = 'border-right: 1px solid',
      # The recipe table that can be toggled by the side panel choices (recipe type, etc.)
      p("Welcome to the Sweet Road!", align = "center"),
      strong("Step 1"),
      em(
        "Use the left side panel to narrow down recipes to narrow down to your desired recipe options"
      ),
      br(),
      strong("Step 2"),
      em(
        "Select the recipes you are interested in and the corresponding ingredients and steps for the recipes will show in the tables below. "
      ),
      br(),
      br(),
      strong("Available Recipes Table"),
      p(
        "All of the available recipes are available below (and we are looking forward to hosting your favorite recipes soon, but more on that later!).",
        style = "font-family: 'times'; font-si16pt"
      ),
      dataTableOutput(ns('recipe_table')),
      tags$style(
        type = "text/css",
        
        ".shiny-output-error { visibility: hidden; }",
        
        ".shiny-output-error:before { visibility: hidden; }"
        
      )),
    column(5,
             plotOutput(
               ns('sweetness_servings_plot'), height = 350
             ))
    ),
    hr(style = "border-top: 1px solid #000000;"),
    
    fluidRow(column(6,
                    strong("Ingredients Needed Table"),
                    p(
                      "The ingredients to make the recipes you selected will be listed in the table below. Use the buttons to Copy, Print, or Save the data to PDF, CSV, or to an Excel sheet.",
                      style = "font-family: 'times'; font-si16pt"
                    ),
                    dataTableOutput(
                      ns("ingredients_table")
                    )),
             column(6,
                    strong("Recipe Steps Table"),
                    p(
                      "The steps to make the recipes you selected will be listed in the table below. Feel free to use the buttons to Copy, Print, or Save the data to PDF, CSV, or to an Excel sheet.",
                      style = "font-family: 'times'; font-si16pt"
                    ),
                    dataTableOutput(
                      ns("steps_table")
                    )))
    # Output: A selector to show you which dessert type you selected
    # This will eventually either be deleted or modified ----
    # The table that outputs the ingredients to make the recipes
    # The table that outputs the steps to make the recipes
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
        # output$recipe_type_sel <- renderText({
        #   recipe_type <- rec_options()$recipe_options
        #   
        #   paste0("You selected ", recipe_type)
        # })
        
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
              dplyr::select(recipe_submitter,
                            recipe_name,
                            recipe_type,
                            sweetie_scale,
                            servings_total) %>%
              unique()
            # If the recipe type is not "All"
          } else if (recipe_type_selected != "all") {
            recipe_name_data <- recipe_name_data_filt %>%
              # filter to the recipe type associated with the recipe that was submitted
              dplyr::filter(recipe_type %in% recipe_type_selected,
                            ingredient  %in% ings_needed,) %>%
              # Only select the unique identifiers for the recipes
              dplyr::select(recipe_submitter,
                            recipe_name,
                            recipe_type,
                            sweetie_scale,
                            servings_total) %>%
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
              dplyr::select(recipe_submitter,
                            recipe_name,
                            recipe_type,
                            sweetie_scale,
                            servings_total) %>%
              unique()
            
          } else {
            # Or else only filter the ingredients
            recipe_name_data <- recipe_name_data_filt   %>%
              dplyr::filter(ingredient %in% ings_needed) %>%
              # select only the unique identifiers for the recipe
              dplyr::select(recipe_submitter,
                            recipe_name,
                            recipe_type,
                            sweetie_scale,
                            servings_total) %>%
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
            # filtered_frame(),
            rownames = FALSE,
            colnames = c(
              'Recipe Submitter',
              'Recipe Name',
              'Recipe Type',
              'Sweetness Scale',
              'Total Servings'
            ),
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
        
        ######################################### Sweetness & Servings Plot ###################
        
        
        output$sweetness_servings_plot <- renderPlot({
          # Selecting the rows that the user clicked on in the above dataframe
          selected <<- input$recipe_table_rows_selected
          
          dataset <- dataset() %>%
            dplyr::select(sweetie_scale, servings_total)
          
          par(mar = c(4, 4, 1, .1))
         plot(dataset, main = "Sweetness x Servings Table", xlab = "Sweetness Scale", ylab = "Servings Made", bg = "pink", col = "blue", pch = 23, cex = 2, font.lab = 2)
          
         
         if (length(selected))
            points(dataset[selected, , drop = FALSE])
        
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