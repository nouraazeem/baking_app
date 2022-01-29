# This creates new recipe
## This will be for the first tab that hsows you the options available

# metric module ----
submit_new_recipe_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    # Action button to submit the recipes
    actionButton(inputId = ns("submit"), label = "Submit New Recipe"),
    # Actions button to reset the tables
    actionButton(inputId = ns("reset"), label = "Reset all tables"),
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
                 
                 # # The name of the recipe submitter
                 # recipe_submitter = "Enter your name"
                 # # The name of the recipe
                 # recipe_name = "Enter recipe name"
                 # # The type of recipe (cake, cake pop, pie, etc.)
                 # recipe_type = "Select recipe type"
                 # # The level of sweetness of the dessert
                 # sweetness_scale = "Select sweetness"
                 # # The time to make the dessert in minutes
                 # servings_total = "How many servings?"
                 # # Date recipe was submitted
                 # current_date = Sys.Date()
                 #
                 # # Take all of the aforementioned columns and create a dataframe
                 # submitter_details = data.frame(recipe_submitter = recipe_submitter,
                 #                                recipe_name = recipe_name, recipe_type = recipe_type,
                 #                                sweetness_scale = sweetness_scale,
                 #                                servings_total = servings_total, current_date =
                 #                                  current_date, stringsAsFactors = FALSE)
                 #
                 
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
                   #if (!is.null(DF))
                   
                   # # The name of the recipe submitter
                   # recipe_submitter = "Enter your name"
                   # # The name of the recipe
                   # recipe_name = "Enter recipe name"
                   # # The type of recipe (cake, cake pop, pie, etc.)
                   # recipe_type = "Select recipe type"
                   # # The level of sweetness of the dessert
                   # sweetness_scale = "Select sweetness"
                   # # The time to make the dessert in minutes
                   # servings_total = "How many servings?"
                   # # Date recipe was submitted
                   # current_date = Sys.Date()
                   #
                   # # Take all of the aforementioned columns and create a dataframe
                   # submitter_details = data.frame(recipe_submitter = recipe_submitter,
                   #                                recipe_name = recipe_name, recipe_type = recipe_type,
                   #                                sweetness_scale = sweetness_scale,
                   #                                servings_total = servings_total, current_date =
                   #                                  current_date, stringsAsFactors = FALSE)
                   # DROPDOWN OPTIONS -- sweetness + cake type
                   sweetness <- 1:5
                   types_of_desserts <-
                     c(
                       "Cake",
                       "Cake Pop",
                       "Cheesecake",
                       "Cookie",
                       "Pie/Tart",
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
                   Amount = c("1 cup", "2 cups", "1 package", "2 tbspns", "1 stick",
                              "1 tspn")
                   # Enter the name of the ingredient needed
                   Ingredient = c("Sugar",
                                  "Flour",
                                  "Almonds",
                                  "Vanilla Extract",
                                  "Butter",
                                  "Cinnamon")
                   # Create a dataframe with the two columns
                   ingredients_df = data.frame(
                     Amount = Amount,
                     Ingredient = Ingredient,
                     stringsAsFactors = FALSE
                   )
                   
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
                 # Step number 1:5
                 Step.number = 1:5
                 # Recipe Steps
                 recipe_step_details = c(
                   "Mix all the dry ingredients",
                   "Mix all the wet ingredients",
                   "Preheat the oven to 350",
                   "Mix all ingredients",
                   "Put into a greased pan and keep in oven until a toothpick
                                         comes out clean"
                 )
                 
                 steps_data <- reactive({
                   
                 })
                 # Crate the HOT that will hold the steps of creating the recipe
                 output$submit_new_steps_hot <-
                   renderRHandsontable({
                     # Create a template df for steps of the recipe
                     
                     # Step number 1:5
                     Step.number = 1:5
                     # Recipe Steps
                     recipe_step_details = c(
                       "Mix all the dry ingredients",
                       "Mix all the wet ingredients",
                       "Preheat the oven to 350",
                       "Mix all ingredients",
                       "Put into a greased pan and keep in oven until a toothpick comes out clean"
                     )
                     # Bind above columns into a df
                     step_details = data.frame(
                       Step.number = Step.number,
                       recipe_step_details = recipe_step_details,
                       stringsAsFactors = FALSE
                     )
                     
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
                 
                 # Click on action button to see df
                 observeEvent(input$submit, {
                   submitter_info <- submitter_df() %>%
                     select(recipe_submitter, recipe_name, current_date)
                   
                   ings_df <- ings_df()
                   
                   steps_df <- steps_df()
                   
                   final_steps <- cbind(submitter_info, steps_df)
                   final_ings <- cbind(submitter_info, ings_df) %>% 
                     dplyr::rename("amount" = "Amount", 
                                   "ingredient" = "Ingredient") %>% 
                     dplyr::mutate(#current_date_bake = as.character(current_date),
                                   recipe_submitter = tolower(gsub(" ", "_", recipe_submitter)),
                                   recipe_name = tolower(gsub(" ", "_", recipe_name)),
                                   amount = tolower(gsub(" ", "_", amount)),
                                   ingredient = tolower(gsub(" ", "_", ingredient))) %>% 
                     dplyr::select(-current_date) %>% 
                     ungroup()
                   
                   browser()
                   data <- final_ings
                     Sys.setenv(PGGSSENCMODE = "disable")
                     
                     con <-
                       dbConnect(
                         RPostgres::Postgres(),
                         dbname = 'bitdotio',
                         host = 'db.bit.io',
                         port = 5432,
                         user = 'bitdotio',
                         password = rstudioapi::askForPassword('Database Password')
                       )
                     
dummy_data <- as.data.frame(1:5)

                     column_names <- colnames(data)
                     data1 <- as.character((data[1,]))
                     values <- gsub(" ", ".", values)
                     
                     query2 <- sprintf('INSERT INTO "nouraazeem/baking_recipes"."ingredients_needed" (recipe_submitter, recipe_name, current_date_bake, amount, ingredient) VALUES (1,2,3,4,5)')
                     query2 <- sprintf(paste('INSERT INTO "nouraazeem/baking_recipes"."ingredients_needed" (recipe_submitter, recipe_name, current_date_bake, amount, ingredient) VALUES ', data))
                     
                     TABLE_NAME <- '"nouraazeem/baking_recipes"."ingredients_needed"'
                     query2 <- sprintf("INSERT INTO %s (%s) VALUES ('%s')", TABLE_NAME,
                                      paste(names(data), collapse = ", "), paste(data, collapse = "', '"))
                     # query2 <- sprintf("INSERT INTO %s (%s) VALUES ('%s')", TABLE_NAME, 
                     #                  names(data), data)
                     
                     ex2 <- dbSendQuery(con, query2)
                     
                     
                     query1 <- sprintf('SELECT * FROM "nouraazeem/baking_recipes"."ingredients_needed"' )
                     
                     query <- sprintf("SELECT * FROM %s", TABLE_NAME)
                     data <- dbGetQuery(con, query)
                     
                     
                                      # 
                                      # VALUES 1,2,3,4,5;)
                     
                   #  ex <- dbGetQuery(con, query1)
                     
                     
                   #  ex1 <- dbWriteTable(conn = con, name = '"nouraazeem/baking_recipes"."ingredients_needed"', data, append = T)
                     
                     
                     
                     # return(list(final_steps = final_steps,
                     #             final_ings = final_ings))
                     # 
                   })

                 # final_steps <- reactive({
                 #   submitter_info <- submitter_df() %>%
                 #     select(recipe_submitter, recipe_name, current_date)
                 #
                 #   steps_df <- steps_df()
                 #   final_steps <- cbind(submitter_info, steps_df)
                 #
                 #   return(reactive(final_steps))
                 # })
                 #
                 # final_ingreds <- reactive({
                 #   submitter_info <- submitter_df() %>%
                 #     select(recipe_submitter, recipe_name, current_date)
                 #
                 #   ings_df <- ings_df()
                 #
                 #   final_ings <- cbind(submitter_info, ings_df)
                 #   return(reactice(final_ings))
                 #
                 # })
                 #
                 
                 
                 
                 
                 
                 
                 
                 
                 #   clicked <- reactiveValues(submit = FALSE, reset = FALSE)
                 #
                 #      initial_hot <- rhandsontable(as.data.frame(matrix(NA_integer_, nrow = 3, ncol = 3)))
                 #   #   correct_values <- as.data.frame(matrix(1:9, nrow = 3, byrow = TRUE))
                 #   #
                 #     observeEvent(input$submit, {
                 #       clicked$submit <- TRUE
                 #       clicked$reset <- FALSE
                 #     })
                 #
                 #     updated_hot <- eventReactive(input$submit, {
                 #       input_values <- hot_to_r(input$submit_new_steps_hot)
                 #       update_hot(input_values = input_values)
                 #       #, correct_values = correct_values
                 #     })
                 #
                 #     observeEvent(input$reset, {
                 #       clicked$reset <- TRUE
                 #       clicked$submit <- FALSE
                 #     })
                 #
                 #     reset_hot <- eventReactive(input$reset, {
                 #       recipe_step_details
                 #     })
                 #
                 #
                 #     output$submit_new_steps_hot <- renderRHandsontable({
                 #
                 #       if(!clicked$submit & !clicked$reset){
                 #         out <- initial_hot
                 #       } else if(clicked$submit & !clicked$reset){
                 #         out <- updated_hot()
                 #       } else if(clicked$reset & !clicked$submit){
                 #         out <- reset_hot()
                 #       }
                 #
                 #       out
                 #   })
                 #
                 
                 # })
             #    })
  
  
              # }
})
  }
               