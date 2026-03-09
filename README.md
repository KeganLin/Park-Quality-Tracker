Overview

This project is a small Shiny app used to track park facility issues such as broken equipment or safety problems. Users can submit reports through a form and the information is stored in a Supabase PostgreSQL database. The dashboard reads the database and displays a summary, a chart of reports by park, and a table of recent reports.

How to Run

First install the required packages in R if they are not already installed. These packages include shiny, DBI, RPostgres, dplyr, DT, and ggplot2.

After installing the packages, run the application with:\
shiny::runApp("midterm")

The app can also be started by clicking the Run App button in RStudio or Posit Cloud.

Database Connection\
The application connects to a Supabase PostgreSQL database using the R packages DBI and RPostgres.
