library(shiny)
library(tidyverse)
library(bslib)
library(bsicons)
library(googlesheets4)

gs4_auth(
  
  cache = ".token",
  
  email = "hajer.boussetta91@gmail.com"
  
)

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
                  step = 1),
      
      # Input for observation button
      actionButton(inputId = "write", label = "Write in Google Sheet")
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
  
  # Reactive expression to calculate predicted VIP attendance once
  predicted_vip <- reactive({
    Predict_VIP_attendance()(
      as.numeric(input$sel_year), 
      as.numeric(stilling_result()$low), 
      as.numeric(stilling_result()$medium), 
      as.numeric(stilling_result()$top), 
      as.numeric(input$ferieefterårsferie), 
      as.numeric(input$sel_rain), 
      as.numeric(input$sel_win_ratio_3), 
      as.numeric(input$sel_dag_kategori_feriehverdag_efterårsferie)
    )
  })
  
  # Output UI for predicted VIP attendance
  output$Predict_VIP_attendance <- renderUI({
    # Use the reactive expression to get the prediction
    Predicted_VIP_attendance <- predicted_vip()
    
    # Value box prediction
    bslib::value_box(
      title = "The predicted VIP attendance is:",
      value = Predicted_VIP_attendance,
      showcase = bs_icon("bank2"),
      class = "bg-danger"
    )
  })
  
  # Observe when the "write" button is clicked and write to Google Sheet
  observeEvent(input$write, {
    sheet_id <- "1Yk4QKJsOHkjKc8PA6iSSLuMh6z7C3UUcL_eOodElI-o"  # Replace with your actual Google Sheet ID
    
    # Create a data frame with the prediction result
    df <- data.frame(
      "Year" = input$sel_year,
      "Opponent_Position" = input$modstanderhold_stilling_superligua,
      "win_ratio_in_the_last_3_matches"=input$sel_win_ratio_3,
      "Predicted_VIP_Attendance" = predicted_vip()
    )
    
    # Append the data frame to the Google Sheet
    sheet_append(sheet_id, df)
    
    showNotification("Predicted VIP attendance written to Google Sheet", type = "message")
  })
}



# Run the application
shinyApp(ui = ui, server = server)
