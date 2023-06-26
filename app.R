library(shiny)
library(readxl)
library(DT)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Fancy Excel"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            fileInput('input_data', 'Please select your DESeq2 DGE analysis results')
        ),
        # Show a plot of the generated distribution
        mainPanel(
           dataTableOutput("table")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  # Req input data
  input_data <- reactive({
    req(input$input_data)
    data <- read_excel(input$input_data$datapath)
  })
  
  
  output$table <- renderDT({
    req(input_data())
  # Plot the table
  DT::datatable(
    input_data(),
    rownames = FALSE,
    filter = "top",
    options = list(
      pageLength = 50,
      scrollX = F,
      columnDefs = list(list(
        className = 'dt-center', targets = 0:(ncol(input_data())-1)))))
  }) 
}

# Run the application 
shinyApp(ui = ui, server = server)
