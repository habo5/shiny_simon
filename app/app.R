library(shiny)
library(tidyverse)
library(bslib)
library(bsicons)

# Define UI for application
ui <- fluidPage(
  
  title = "VFF_Datavisualisering",
  
  # Application title
  titlePanel("EA Dania 2025"),
  
  # Sidebar layout
  sidebarLayout(
    sidebarPanel(
      
      # Logo
      div(img(height = 65, width = 80, src = "dania_logo.png"), # Her indsætter jeg et logo
          style = "text-align: center;"),
      
      # Radio buttons for 'dag_kategori_feriehverdag_efterårsferie'
      radioButtons("sel_dag_kategori_feriehverdag_efterårsferie",
                   "Select if it is  dag_kategori_feriehverdag_efterårsferie' (Yes or No)",
                   choices = list("Yes" = 1, "No" = 0),
                   selected = 1),
      
      # Radio buttons for team 'stilling' (Low, Medium, or Top)
      radioButtons("modstanderhold_stilling_superligua",
                   "Select the opponent position (Low, Medium, or Top)",
                   choices = list("Low" = "low", "Medium" = "medium", "Top" = "top"),
                   selected = "low"),
      
      # Radio buttons for 'ferieefterårsferie' (Yes or No)
      radioButtons("ferieefterårsferie",
                   "Select 'ferieefterårsferie' (Yes or No)",
                   choices = list("Yes" = 1, "No" = 0),
                   selected = 1),
      
      # Input for 'rain'
      numericInput("sel_rain",
                   "Select if it will rain (1 = Yes, 0 = No)",
                   min = 0,
                   max = 1,
                   value = 0),
      
      sliderInput("sel_win_ratio_3",
                  "Select the 'win_ratio_3' value",
                  min = 0,
                  max = 1,
                  value = 0,
                  step = 1/3),
      
      
      # Slider for 'år' (year)
      sliderInput("sel_year",
                  "Select the year ",
                  min = 2000,
                  max = 2030,
                  value = 2025,
                  step = 1)
    ),
    
    # Main panel
    mainPanel(
      tabsetPanel(tabPanel("Predicted_VIP_attendance",
                           uiOutput("Predict_VIP_attendance"))
      )
    )
  )
)

# Define server logic
server <- function(input, output) {
  
  # Load the modstanderhold_stilling function from the RDS file
  modstanderhold_stilling <- readRDS("C:/Users/hajer/OneDrive/Documents/GitHub/shiny_simon/app/modstanderhold_stilling.Rds")
  
  # Reactive expression to get the team 'stilling' based on user selection
  stilling_result <- reactive({
    modstanderhold_stilling(input$modstanderhold_stilling_superligua)
  })
  
  # Load Predict_VIP_attendance model
  Predict_VIP_attendance <- reactive({ readRDS("predict_VIP_attendance.Rds") })
  
  # Output UI for predicted VIP attendance
  output$Predict_VIP_attendance <- renderUI({
    
    # Get the predicted VIP attendance from the model
    Predicted_VIP_attendance <- Predict_VIP_attendance()(
      as.numeric(input$sel_year), 
      as.numeric(stilling_result()$low), 
      as.numeric(stilling_result()$medium), 
      as.numeric(stilling_result()$top), 
      as.numeric(input$ferieefterårsferie), 
      as.numeric(input$sel_rain), 
      as.numeric(input$sel_win_ratio_3), 
      as.numeric(input$sel_dag_kategori_feriehverdag_efterårsferie)
    )
    
    # Value box prediction
    bslib::value_box(
      title = "The predicted VIP attendance is:",
      value = Predicted_VIP_attendance,
      showcase = bs_icon("bank2"),
      class = "bg-danger"
    )
  })
}

# Run the application
shinyApp(ui = ui, server = server)
