library(shiny)
library(DBI)
library(RPostgres)
library(dplyr)
library(DT)
library(ggplot2)

connect_db <- function() {
  dbConnect(
    RPostgres::Postgres(),
    host = "aws-0-us-west-2.pooler.supabase.com",
    port = 5432,
    dbname = "postgres",
    user = "postgres.zffieedewwbjzqlhoqps",
    password = "KeganLin0424.",
    sslmode = "require"
  )
}

ui <- fluidPage(
  titlePanel("Park Facilities Quality Tracker"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput(
        "park_name",
        "Park Name",
        choices = c(
          "Central Park",
          "Prospect Park",
          "Riverside Park",
          "Flushing Meadows Park",
          "Battery Park"
        )
      ),
      
      selectInput(
        "issue_type",
        "Issue Type",
        choices = c(
          "Broken Swing",
          "Wet Surface",
          "Loose Fence",
          "Broken Slide",
          "Glass Debris",
          "Damaged Bench",
          "Exposed Bolt",
          "Trash Overflow",
          "Loose Mat",
          "Broken Gate"
        )
      ),
      
      numericInput(
        "severity",
        "Severity (1 to 5)",
        value = 3,
        min = 1,
        max = 5
      ),
      
      textInput(
        "reported_by",
        "Reported By",
        value = ""
      ),
      
      textInput(
        "notes",
        "Notes",
        value = ""
      ),
      
      actionButton("submit", "Submit Report"),
      br(),
      br(),
      textOutput("submit_message")
    ),
    
    mainPanel(
      h3("Summary"),
      verbatimTextOutput("summary_text"),
      
      h3("Reports by Park"),
      plotOutput("park_plot"),
      
      h3("Recent Reports"),
      DTOutput("recent_table")
    )
  )
)

server <- function(input, output, session) {
  
  refresh <- reactiveVal(0)
  
  observeEvent(input$submit, {
    con <- connect_db()
    
    dbExecute(
      con,
      "insert into quality_reports (park_name, issue_type, severity, notes, reported_by)
       values ($1, $2, $3, $4, $5)",
      params = list(
        input$park_name,
        input$issue_type,
        input$severity,
        input$notes,
        input$reported_by
      )
    )
    
    dbDisconnect(con)
    
    output$submit_message <- renderText("Report submitted successfully.")
    refresh(refresh() + 1)
  })
  
  report_data <- reactive({
    refresh()
    
    con <- connect_db()
    df <- dbGetQuery(
      con,
      "
      select id, park_name, issue_type, severity, notes, reported_by, reported_at
      from quality_reports
      order by reported_at desc
      "
    )
    dbDisconnect(con)
    
    df
  })
  
  output$summary_text <- renderText({
    df <- report_data()
    
    paste0(
      "Total reports: ", nrow(df), "\n",
      "Average severity: ", round(mean(df$severity), 2), "\n",
      "Most recent report time: ", df$reported_at[1]
    )
  })
  
  output$park_plot <- renderPlot({
    df <- report_data()
    
    plot_df <- df %>%
      count(park_name)
    
    ggplot(plot_df, aes(x = park_name, y = n)) +
      geom_col() +
      labs(
        x = "Park Name",
        y = "Number of Reports",
        title = "Safety Reports by Park"
      ) +
      theme_minimal()
  })
  
  output$recent_table <- renderDT({
    datatable(
      report_data(),
      options = list(pageLength = 10)
    )
  })
}

shinyApp(ui = ui, server = server)