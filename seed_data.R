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

dbExecute(con, "
insert into quality_reports (park_name, issue_type, severity, notes, reported_by)
values
('Central Park', 'Broken Swing', 4, 'Chains appear loose near the swing set', 'Alex'),
('Prospect Park', 'Wet Surface', 2, 'Rubber flooring is slippery after rain', 'Jamie'),
('Riverside Park', 'Loose Fence', 5, 'Fence panel is unstable near toddler area', 'Morgan'),
('Flushing Meadows Park', 'Broken Slide', 4, 'Crack found on the lower section of slide', 'Taylor'),
('Battery Park', 'Glass Debris', 3, 'Small pieces of glass found near benches', 'Jordan'),
('Central Park', 'Damaged Bench', 2, 'Bench armrest is broken', 'Casey'),
('Prospect Park', 'Exposed Bolt', 5, 'Metal bolt exposed near climbing area', 'Riley'),
('Riverside Park', 'Trash Overflow', 1, 'Trash bin is overflowing beside playground', 'Avery'),
('Flushing Meadows Park', 'Loose Mat', 3, 'Ground safety mat is lifting at one edge', 'Drew'),
('Battery Park', 'Broken Gate', 4, 'Gate latch is not locking properly', 'Quinn');
")

cat('Synthetic data inserted successfully.\n')

preview_data <- dbGetQuery(con, "
select * 
from quality_reports
order by reported_at desc;
")

print(preview_data)

dbDisconnect(con)

cat('Disconnected successfully.\n')