

# Load and options --------------------------------------------------------
library(shiny)
options(shiny.maxRequestSize = 30*1024^2)


# Test --------------------------------------------------------------------
# 
# arquivo <- readxl::read_xlsx("data-raw/Base_woodstock_OTA2.xlsx")
# 
# arquivo |> 
#     as.data.frame() |> 
#     foreign::write.dbf(file = "data/Base_woodstock_OTA2.dbf")
# 
# # 
# hp_ws_filled |>
#     dplyr::select(-PERIOD) |>  # remove PERIOD column
#     as.data.frame() |>         # convert to data frame
#     dplyr::mutate(
#         REMSOFT_ID = as.integer(REMSOFT_ID),
#         ACTION = as.integer(ACTION),
#         CUT_PERIOD = as.integer(CUT_PERIOD),
#         IDADE = as.integer(IDADE)
#     ) |>
#     foreign::write.dbf(file = "data/outputs/Base_woodstock_OTA2.dbf")


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
        
        # uiOutput
        shiny::uiOutput(outputId = "out_variable_selector"),
        
        # download
        shiny::downloadButton(outputId = "out_download")
        
        # output [1]
        # shiny::tableOutput(outputId = "out_preview1"),
        
    )
)

# see only the columns of a dataframe
# names(mtcars) |> tibble::as_tibble() |> dplyr::rename(variavel = "value")


# Server ------------------------------------------------------------------

server <- function(input, output, session) {
    
    # Upload --------------------------------------------------------------
    raw_file <- shiny::reactive({
        shiny::req(input$inp_file)
        readxl::read_excel(path = input$inp_file$datapath) |> as.data.frame()
    })

    # output$out_preview1 <- shiny::renderTable({head(raw_file(), n=5)})
    # output$out_preview1 <- shiny::renderTable(dplyr::glimpse(raw_file()))
    
    # see details of the file
    # output$out_preview1 <- shiny::renderTable({input$inp_file})
    
    # Transform -----------------------------------------------------------
    output$out_variable_selector <- shiny::renderUI(
        # input columns [2]
        shiny::varSelectInput(
            inputId = "inp_variable",
            label = "Coluna:",
            data = raw_file()
        )
    )
    
    # tidied_data <- shiny::reactive({
    #     
    #     req(input$inp_variable)
    #     raw_file() |> 
    #         dplyr::mutate(
    #             # !!input$inp_variable = as.integer(!!input$inp_variable)
    #         )
    #     
    #     # if (is.null(tidied_data())) {
    #     #     tidied_data() <- raw_file()
    #     # }
    #     
    # })
    
    
    # Download ------------------------------------------------------------
    output$out_download <- downloadHandler(
        
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
