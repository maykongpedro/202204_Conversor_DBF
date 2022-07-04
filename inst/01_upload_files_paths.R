
# Book Mastering Shiny --------------------------------------
# 9. Uploads and downloads ----------------------------------

# https://mastering-shiny.org/action-transfer.html
# Script 1 - Understanding  the paths of uploaded files
# Objective: upload some files and see the paths in the table


library(shiny)

ui <- fluidPage(
    
    # input
    fileInput(
        inputId = "upload",
        label = "Carregue arquivos",
        buttonLabel = "Upload...",
        multiple = TRUE
    ),
    
    # output
    tableOutput(outputId = "files")
)



server <- function(input, output, session) {
    
    output$files <- renderTable(input$upload)
    
}

shinyApp(ui, server)