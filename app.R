

# Load and options --------------------------------------------------------
library(shiny)
options(shiny.maxRequestSize = 30*1024^2)

# Ui ----------------------------------------------------------------------
ui <- shiny::navbarPage(
    
    title = "Conversor para DBF",
    
    # inside of a navbarPage its necessary put thing inside 'tabPanels'
    shiny::tabPanel(
        title = "Painel principal",
        shiny::h3("Importar dados"),
        
        # input data [1]
        shiny::fileInput(
            inputId = "inp_file",
            label = "Selecione o arquivo que deseja converter",
            multiple = FALSE
        ),
        
        
        shiny::radioButtons(
            inputId = "choose_class",
            label = "",
            choices = list(
                Numeric = "Numeric",
                Integer = "Integer",
                Factor = "Factor",
                Character = "Character",
                Date = "Date"
            ),
            selected = ""
        ),
        
        shiny::actionButton(inputId = "chg_class", label = "Change"),
        
        # uiOutput [1] - column selector
        shiny::uiOutput(outputId = "var_selector"),
        
        # uiOutput [2] - column type
        shiny::textOutput(outputId = "var_type"),
        
        # download
        shiny::downloadButton(outputId = "out_download")
        
        # output [1]
        # shiny::tableOutput(outputId = "out_preview1"),
        
    )
)


# Server ------------------------------------------------------------------

server <- function(input, output, session) {
    
    # Upload --------------------------------------------------------------
    # raw_data <- shiny::reactive({
    #     shiny::req(input$inp_file)
    #     readxl::read_excel(path = input$inp_file$datapath) |> as.data.frame()
    # })
    
    raw_data <- shiny::reactiveVal(mtcars)


    # see details of the file
    # output$out_preview1 <- shiny::renderTable({input$inp_file})
    
    # Transform -----------------------------------------------------------
    output$var_selector <- shiny::renderUI(
        
        shiny::selectInput(
            inputId = "var",
            label = "Selecione a coluna para trocar o tipo de dado:",
            choices = names(raw_data())
        )
        
    )
    
    # Show the type of the selected column
    output$var_type <- shiny::renderText({
        shiny::req(input$var)
        print(raw_data()[, input$var] |> class())

    }
    )
    
    # Convert type of the selected column
    # modified_file <- shiny::reactiveVal(raw_data())
    shiny::observeEvent(input$chg_class, {

        nome_col <- input$var
        database <- raw_data() |> as.data.frame()
        # nome_col <- "mpg"
        # database <- modified_file() |> as.data.frame()
        # database <- mtcars |> as.data.frame()

        switch(
            input$choose_class,
            "Character" = database[, nome_col] <- as.character(database[, nome_col]),
            "Integer" = database[, nome_col] <- as.integer(database[, nome_col]),
            "Factor" = database[, nome_col] <- as.factor(database[, nome_col]),
            "Numeric" = database[, nome_col] <- as.integer(database[, nome_col]),
            "Date" = database[, nome_col] <- as.date(database[, nome_col])
        )

        # modified_file(database) # update modified_file()
        raw_data(database) # update modified_file()


        # Faz a troca toda vez que clico no botao "change"
        # Preciso salvar o resultado para que depois da primeira vez ele sempre
        # use o próprio modified file para realizar esse procedimento

        # SÓ ESTÁ SENDO CHAMADO QUANDO CLICO PRA FAZER O DOWNLOAD, PQ?
         # modified_file <- shiny::reactive({
         #
         #     # shiny::req(input$var)
         #     nome_col <- input$var
         #     database <- raw_file() |> as.data.frame()
         #     browser()
         #     switch(
         #         input$choose_class,
         #         "Character" = database[, nome_col] <- as.character(database[, nome_col]),
         #         "Integer" = database[, nome_col] <- as.integer(database[, nome_col]),
         #         "Factor" = database[, nome_col] <- as.factor(database[, nome_col]),
         #         "Numeric" = database[, nome_col] <- as.integer(database[, nome_col]),
         #         "Date" = database[, nome_col] <- as.date(database[, nome_col])
         #     )
         #
         #     # modified_file() <- database
         #     # raw_file(database)
         #     database
         # })

    })
    
    
    
    # Download ------------------------------------------------------------
    output$out_download <- shiny::downloadHandler(
        
        filename = function() {
            paste0(
                stringr::str_remove(
                    string = input$inp_file$name,
                    pattern = glue::glue(".", tools::file_ext(input$inp_file$name))
                ),
                ".dbf"
            )
        },
        
        content = function(file) {
            # foreign::write.dbf(modified_file(), file)
            foreign::write.dbf(raw_data(), file)
        }
        
        
    )

}

shinyApp(ui, server)
