

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
            multiple = FALSE,
        ),
        
        # input columns [2]
        shiny::varSelectInput(
            inputId = "inp_variablel",
            label = "Coluna:",
            data = mtcars
        ),
        
        # output [1]
        shiny::tableOutput(outputId = "out_preview1"),
        
    )
)

# see only the columns of a dataframe
# names(mtcars) |> tibble::as_tibble() |> dplyr::rename(variavel = "value")


# Server ------------------------------------------------------------------

server <- function(input, output, session) {
    
    # Upload --------------------------------------------------------------
    raw_file <- shiny::reactive({
        shiny::req(input$inp_file)
        readxl::read_excel(path = input$inp_file$datapath)
    })
    output$out_preview1 <- shiny::renderTable({head(raw_file(), n=5)})
    
    # see details of the file
    # output$out_preview1 <- shiny::renderTable({input$inp_file})
    
    # Transform -----------------------------------------------------------
    
    
    
    # Download ------------------------------------------------------------
    

}

shinyApp(ui, server)
