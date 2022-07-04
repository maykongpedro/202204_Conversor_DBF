
library(shiny)

# To make it easier to understand how to use the app, I used sidebarLayout() 
# to divide the app into three main steps:
# 1.Uploading and parsing the file
# 2.Chosing a option to transform the file.
# 3.Downloading the file


# 1.Uploading and parsing the file ----------------------------------------
ui_upload <- sidebarLayout(
  sidebarPanel = sidebarPanel(
    
    fileInput(
      inputId = "arquivo",
      label = "Carregue um arquivo excel para converter",
      multiple = FALSE,
      accept = c("xlsx", "xls")
    ),
    
    numericInput(
      inputId = "linhas",
      label = "Linhas para mostrar na pré-visualização",
      value = 5,
      min = 1,
      max = 10
    )
    
  ),
  
  mainPanel = mainPanel(
    h3("Pré-visualização dos dados carregados:"),
    tableOutput(outputId = "pre_visualiacao")
  )
)



# 2.Chosing a option to transform the file --------------------------------
ui_transform <- sidebarLayout(
    sidebarPanel = sidebarPanel(
      
    ),
    
    mainPanel = mainPanel(
      
    )
)


# 3. Downloading the file -------------------------------------------------
ui_download <- fluidRow(
    
)


# Ui ----------------------------------------------------------------------

ui <- fluidPage(
    ui_upload,
    ui_transform,
    ui_download
)


# Server ------------------------------------------------------------------

server <- function(input, output, session) {
  

  # Upload ------------------------------------------------------------------
  raw_data <- reactive({
    
    # require file input
    req(input$arquivo)
    
  })
  
  
}

shinyApp(ui, server)