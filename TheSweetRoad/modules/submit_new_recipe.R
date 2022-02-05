# This creates new recipe
## This will be for the first tab that shows you the options available

# metric module ----
submit_new_recipe_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    # Action button to submit the recipes
    actionButton(inputId = ns("submit"), label = "Submit New Recipe"),
    # Generates the HOT for users to submit name, dessert, date, type of dessert, sweetness, etc.
    rHandsontableOutput(ns("submit_new_name_hot")),
    tags$style(type = "text/css", "#submit_new_name_hot th {font-weight:bold;}"),
    # Generate the HOT for users to submit the ingredients needed for their dessert + quantities
    # of ingredients
    rHandsontableOutput(ns("submit_new_ing_hot")),
    # Generates the HOT for users to submit the steps for making a dessert
    rHandsontableOutput(ns("submit_new_steps_hot"))
  )
  
}

submit_new_recipe_server <- function(id, input, output, session) {
  # Calling the moduleServer function
  moduleServer(id,
               function(input, output, session) {
                 ns <- session$ns
                 
                 values = reactiveValues(DF = submitter_details)
                 
                 submitter_table = reactive({
                   if (!is.null(input$submit_new_name_hot)) {
                     DF = hot_to_r(input$submit_new_name_hot)
                   } else {
                     DF = values$DF
                   }
                 })
                 
                
                 #################################################### HOT 1 ###############################################
                 output$submit_new_name_hot <- renderRHandsontable({
                   # Now we will build out the handsontable using our default data frame
                   # Create columns for the default table that will be used to capture:

                   submitter_details = submitter_table()
                   
                   
                   # DROPDOWN OPTIONS -- sweetness + cake type
                   sweetness <- 1:5
                   types_of_desserts <-
                     c(
                       "Cake",
                       "Cake Pop",
                       "Cheesecake",
                       "Cookie",
                       "Pie or Tart",
                       "Traditional Middle Eastern Dessert"
                     )
                   
                   # Builing the HOT (handsontable) and specifying height x width in the UI for it +
                   # Cleaning up the column headers
                   rhandsontable(
                     submitter_details,
                     rowHeaders = NULL,
                     width = 1000,
                     height = 250,
                     colHeaders = c(
                       "Recipe Submitter",
                       "Recipe Name",
                       "Recipe Type (dropdown)",
                       "How sweet? (dropdown - 1-5)",
                       "Servings Made?",
                       "Current Date"
                     )
                   ) %>%
                     # Allow users to edit the HOT
                     # hot_context_menu(allowRowEdit = TRUE) %>%
                     # Specify column width + center the text within the HOT
                     hot_col(col = 1,
                             colWidths = 150,
                             valign = 'htCenter') %>%
                     # Specify column width + center the text within the HOT
                     hot_col(col = 2,
                             colWidths = 150,
                             valign = 'htCenter') %>%
                     # Specify column width + center the text within the HOT + allow users to select from the
                     # types_of_desserts dropdown
                     hot_col(
                       col = 3,
                       type = "dropdown",
                       source = types_of_desserts,
                       colWidths = 150,
                       valign = 'htCenter'
                     ) %>%
                     # Specify column width + center the text within the HOT + allow users to select from the
                     # sweetness scale dropdown
                     hot_col(
                       col = 4,
                       type = "dropdown",
                       source = sweetness,
                       colWidths = 150,
                       valign = 'htCenter'
                     ) %>%
                     hot_col(col = 5,
                             colWidths = 150,
                             valign = 'htCenter') %>%
                     hot_col(col = 6,
                             colWidths = 150,
                             valign = 'htCenter') %>%
                     # Specify row heights
                     hot_rows(rowHeights = 35)
                 })
                 
                 # I can make some changes to this rhandsontable and generate the resulting table as dataframe
                 values_submitter <-
                   reactiveValues(submitter_data = NULL)
                 
                 observe({
                   values_submitter$submitter_data <-
                     hot_to_r(input$submit_new_name_hot)
                 })
                 
                 # I assign this df to a variable call df1
                 submitter_df <- reactive({
                   values_submitter$submitter_data
                 })
                 
                 
                 
                 #################################################### HOT 2 ###############################################
                 
                 # Create the HOT that will capture ingredients needed for recipe
                 output$submit_new_ing_hot <- renderRHandsontable({
                   # Create the initial df that will host the ingredients needed for the recipe
                   # Enter the amount of the ingredient needed
                   
                   
                   rhandsontable(
                     ingredients_df,
                     rowHeaders = NULL,
                     width = 800,
                     height = 300,
                     colHeaders = c(
                       "Enter the amount of the ingredient",
                       "Enter the name of the ingredient"
                     )
                   ) %>%
                     # Allow users to edit the data
                     # hot_context_menu(allowRowEdit = TRUE) %>%
                     # Specify column width
                     hot_col(1, colWidths = 150,  valign = 'htCenter') %>%
                     hot_col(2, colWidths = 200) %>%
                     hot_rows(rowHeights = 30)
                 })
                 
                 # I can make some changes to this rhandsontable and generate the resulting table as dataframe
                 values_ings <- reactiveValues(ings_data = NULL)
                 
                 observe({
                   values_ings$ings_data <- hot_to_r(input$submit_new_ing_hot)
                 })
                 
                 # I assign this df to a variable call df1
                 ings_df <- reactive({
                   values_ings$ings_data
                 })
                 
                 
                 #################################################### HOT 3 ###############################################
                 steps_data <- reactive({
                   
                 })
                 # Crate the HOT that will hold the steps of creating the recipe
                 output$submit_new_steps_hot <-
                   renderRHandsontable({
                     rhandsontable(
                       step_details,
                       rowHeaders = NULL,
                       width = 500,
                       height = 500,
                       colHeaders = c("Step Number", "Step Details")
                     ) %>%
                       # hot_context_menu(allowRowEdit = TRUE) %>%
                       hot_col(1, colWidths = 75,  valign = 'htCenter') %>%
                       hot_col(2, colWidths = 300) %>%
                       hot_rows(rowHeights = 50)
                     
                     
                   })
                 # I can make some changes to this rhandsontable and generate the resulting table as dataframe
                 values_steps <- reactiveValues(steps_data = NULL)
                 
                 observe({
                   values_steps$steps_data <- hot_to_r(input$submit_new_steps_hot)
                 })
                 
                 # I assign this df to a variable call df1
                 steps_df <- reactive({
                   values_steps$steps_data
                 })
                 
                 # Click on the save new recipe button to save the ingredients to the database
                 observeEvent(input$submit, {
                   # pull in the recipe submitter's information to use as the primary key
                   submitter_info <- submitter_df() %>%
                     dplyr::select(recipe_submitter,
                                   recipe_name,
                                   current_date,
                                   recipe_type,
                                   sweetie_scale, 
                                   servings_total)
                   
                   # pull in the ingredients the user submitted alongside their recipe
                   ings_df <- ings_df()
                   
                   # pull in the steps to make the recipe that the user submitted
                   steps_df <- steps_df()
                   
                   # final ingredients df - bind the recipe submitter's personal information
                   # with the ingredients they need to make their recipe into one df
                   final_ings <- cbind(submitter_info, ings_df) %>%
                     # rename the columns to make it more db friendly
                     dplyr::rename("amount" = "Amount",
                                   "ingredient" = "Ingredient") %>%
                     # Pull in df columns and make more db safe (take away uppercase,
                     # take out spaces, etc.)
                     dplyr::mutate(
                       current_date_bake = as.character(current_date),
                       recipe_submitter = tolower(gsub(" ", "_", recipe_submitter)),
                       recipe_name = tolower(gsub(" ", "_", recipe_name)),
                       recipe_type = tolower(gsub(" ", "_", recipe_type)),
                       amount = tolower(gsub(" ", "_", amount)),
                       ingredient = tolower(gsub(" ", "_", ingredient))
                     ) %>%
                     # Taking out current_date column as we remade it into a character
                     # in the above mutate statement
                     dplyr::select(-current_date) %>%
                     ungroup()
                   
                   
                   # Here we are turning the ingredients dataframe into a simpler,
                   # string format for it to better fit into our db
                   final_ingreds <-
                     paste0(apply(final_ings, 1, function(x)
                       paste0(
                         "('", paste0(x, collapse = "', '"), "')"
                       )), collapse = ", ")
                   
                   # Reference the ingredients_needed remote table we have where the ingredients will
                   # be saved to
                   ingredients_table <-
                     '"nouraazeem/baking_recipes"."ingredients_needed"'
                   
                   # write out the query we need with 3 values to be filled in where you see %s
                   # 1. insert into %s - this first %s is where the table name will be filled in
                   # 2. (%s) this is where the column names from our ingredients df will be stored
                   # 3. VALUES %s - this will store the string of ingredients we made above
                   ingreds_query <-
                     sprintf(
                       "INSERT INTO %s (%s) VALUES %s",
                       ingredients_table,
                       paste(names(final_ings), collapse = ", "),
                       paste(final_ingreds, collapse = ", ")
                     )
                   # now we will send this query to our remote db so that we can store the ingredients needed for the recipe
                   ingreds_db <- dbSendQuery(con, ingreds_query)
                   
                   
                   ################################### ADD STEPS TO DB #######################
                   # Take out sweetness scale + servings made
                   submitter_info <- submitter_info %>% 
                     dplyr::select(-sweetie_scale, -servings_total)
                   
                   # combine the recipe submitter's name + the steps for their recipe as the
                   # fields used to identify a particular recipe
                   final_steps <-
                     cbind(submitter_info, steps_df) %>%
                     # Pull in df columns and make more db safe (take away uppercase,
                     # take out spaces, etc.)
                     dplyr::mutate(
                       current_date_bake = as.character(current_date),
                       recipe_submitter = tolower(gsub(" ", "_", recipe_submitter)),
                       recipe_name = tolower(gsub(" ", "_", recipe_name)),
                       recipe_type = tolower(gsub(" ", "_", recipe_type)),
                       recipe_step_details = tolower(gsub(" ", "_", recipe_step_details))
                     ) %>%
                     # Taking out current_date column as we remade it into a character
                     # in the above mutate statement
                     dplyr::select(-current_date) %>%
                     ungroup()
                   
                   
                   # Here we are turning the recipe steps dataframe into a simpler,
                   # string format for it to better fit into our db
                   final_rec_steps <-
                     paste0(apply(final_steps, 1, function(x)
                       paste0(
                         "('", paste0(x, collapse = "', '"), "')"
                       )), collapse = ", ")
                   
                   # Reference the ingredients_needed remote table we have where the ingredients will
                   # be saved to
                   steps_table <-
                     '"nouraazeem/baking_recipes"."steps_needed"'
                   
                   # write out the query we need with 3 values to be filled in where you see %s
                   # 1. insert into %s - this first %s is where the table name will be filled in
                   # 2. (%s) this is where the column names from our steps df will be stored
                   # 3. VALUES %s - this will store the string of steps we made above
                   steps_query <-
                     sprintf(
                       "INSERT INTO %s (%s) VALUES %s",
                       steps_table,
                       paste(names(final_steps), collapse = ", "),
                       paste(final_rec_steps, collapse = ", ")
                     )
                   # now we will send this query to our remote db so that we can store the steps needed for the recipe
                   steps_db <- dbSendQuery(con, steps_query)
                   
                   
                 })
                 
                 
               })
}
