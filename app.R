

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
            )
            ,
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
    raw_file <- shiny::reactive({
        shiny::req(input$inp_file)
        readxl::read_excel(path = input$inp_file$datapath) |> as.data.frame()
    })

    # see details of the file
    # output$out_preview1 <- shiny::renderTable({input$inp_file})
    
    # Transform -----------------------------------------------------------
    output$var_selector <- shiny::renderUI(
        
        shiny::selectInput(
            inputId = "var",
            label = "Selecione a coluna para trocar o tipo de dado:",
            choices = names(raw_file())
        )
        
    )
    
    # Show the type of the selected column
    output$var_type <- shiny::renderText({
        shiny::req(input$var)
        print(raw_file()[, input$var] |> class())

    }
    )
    
    # Convert type of the selected column
    modified_file <- shiny::reactive({
        
        shiny::req(input$var)
        
        switch(
            input$var,
            "character" = database[, nome_col] <- as.character(database[, nome_col]),
            "integer" = database[, nome_col] <- as.integer(database[, nome_col]),
            "factor" = database[, nome_col] <- as.factor(database[, nome_col]),
            "numeric" = database[, nome_col] <- as.integer(database[, nome_col]),
            "date" = database[, nome_col] <- as.date(database[, nome_col])
        )
        
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
            # writexl::write_xlsx(raw_file(), file)
            # foreign::write.dbf(tidied_data(), file)
            foreign::write.dbf(raw_file(), file)
        }
        
        
    )

}

shinyApp(ui, server)
