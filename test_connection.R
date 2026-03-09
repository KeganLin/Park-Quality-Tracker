library(DBI)
library(RPostgres)

con <- dbConnect(
  RPostgres::Postgres(),
  host = "aws-0-us-west-2.pooler.supabase.com",
  port = 5432,
  dbname = "postgres",
  user = "postgres.zffieedewwbjzqlhoqps",
  password = "KeganLin0424.",
  sslmode = "require"
)

cat("Connected successfully.\n")

test_query <- dbGetQuery(con, "select * from quality_reports limit 5;")
print(test_query)

dbDisconnect(con)

cat("Disconnected successfully.\n")