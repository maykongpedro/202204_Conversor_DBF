
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
      # accept = c("xlsx", "xls")
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
    tableOutput(outputId = "pre_visualizacao")
  )
)



# 2.Chosing a option to transform the file --------------------------------
ui_transform <- sidebarLayout(
    sidebarPanel = sidebarPanel(
      
      # check box inputs to chosse a template of transformation
      
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
    # ui_transform,
    # ui_download
)


# Server ------------------------------------------------------------------

server <- function(input, output, session) {
  

  # Upload ------------------------------------------------------------------
  raw_data <- reactive({
    
    # require file input
    req(input$arquivo)
    
    # get file extension
    ext <- tools::file_ext(input$arquivo$name)
    
    # read file
    switch(
      ext,
      xls = readxl::read_excel(path = input$arquivo$datapath, guess_max = 10000),
      xlsx = readxl::read_excel(path = input$arquivo$datapath, guess_max = 10000),
      validate("Arquivo inválido. Por gentileza, carregue um arquivo excel em formato xls ou xlsx.")
    )
    
  })
  
  # preview
  output$pre_visualizacao <- renderTable(
    expr = head(
      x = raw_data(),
      n = input$linhas
    )
  )
  
  
}

shinyApp(ui, server)