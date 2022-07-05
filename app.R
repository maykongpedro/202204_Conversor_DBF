
# Introduction -----------------------------------------------------------

# Objective: App to facilitate conversion from xlsx files to dbf files
# Support: I used the case study exercise in the 'Mastering Shiny' book as 
# the basis for the structure of this app.
# Link: https://mastering-shiny.org/action-transfer.html

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
    tableOutput(outputId = "preview1")
  )
)



# 2.Chosing a option to transform the file --------------------------------
ui_transform <- sidebarLayout(
    sidebarPanel = sidebarPanel(
      
      # radio buttons inputs to chosse a template of transformation
      radioButtons(
        inputId = "template",
        label = "Escolha o template para conversão",
        choices = c(
          "Shape MP-LP SC" = "shp_sc",
          "Shape MP-LP PR" = "shp_pr",
          "Outro" = "outro"
        ),
        selected = "Outro"
        # selected = character(3)
        
      )
      
    ),
    
    mainPanel = mainPanel(
      h3("Pré-visualização dos dados transformados:"),
      tableOutput(outputId = "preview2")
    )
)


# 3. Downloading the file -------------------------------------------------
ui_download <- fluidRow(
    column(
      
      width = 6,
      
      downloadButton(
        outputId = "download"
      )
    )
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
  output$preview1 <- renderTable(
    expr = head(
      x = raw_data(),
      n = input$linhas
    )
  )
  

  # Transform ---------------------------------------------------------------
  transformed_data <- reactive({
    
    # require radio input selection
    req(input$template)
    
    # get raw data
    raw <- raw_data()
    
    # make a action based in a input template
    switch(
      input$template,
      shp_sc = raw <- transformar_shp_sc(raw),
      shp_pr = raw <- transformar_shp_pr(raw),
      outro = raw <- as.data.frame(raw)
    )
    
    # return data modified
    raw
    
  })
  
  # preview2
  output$preview2 <- renderTable(
    expr = head(
      x = transformed_data(),
      n = input$linhas
    )
  ) 
  

  # Download ----------------------------------------------------------------
  output$download <- downloadHandler(
    
    filename = function(){
      
      # get complete name of the file without extension
      file_path <- tools::file_path_sans_ext(input$arquivo$name)
      paste0(file_path,".dbf")
    },
    
    content = function(file){
      
      # convert and export data
      foreign::write.dbf(
        dataframe = transformed_data(),
        file = file
      )
      
    }
  )
  
}

shinyApp(ui, server)