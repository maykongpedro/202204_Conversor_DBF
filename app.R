
library(shiny)

# To make it easier to understand how to use the app, I used sidebarLayout() 
# to divide the app into three main steps:


# 1.Uploading and parsing the file
# 2.Chosing a option to transform the file.
# 3.Downloading the file


# 1.Uploading and parsing the file ----------------------------------------
ui_upload <- sidebarLayout(
    
)



# 2.Chosing a option to transform the file --------------------------------
ui_transform <- sidebarLayout(
    
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
  
}

shinyApp(ui, server)