# _targets.R
library(targets)
library(RSQLite)
library(tarchetypes)




get_from_database <- function(table, ...) {
  con <- DBI::dbConnect(...)
  on.exit(DBI::dbDisconnect(con))
  dbReadTable(con, table)
}

list(
   tar_target(
     dbfile,
     {con <- dbConnect(RSQLite::SQLite(), "mydb.sqlite")
     DBI::dbWriteTable(con,'cars',cars,overwrite = T)
     DBI::dbDisconnect(con)
     here::here("mydb.sqlite")},
     format = 'file'),
  tar_fst_dt(
    table_from_database,
    get_from_database("cars", drv=RSQLite::SQLite(), dbname = "mydb.sqlite") # ... has use-case-specific arguments.

  )
)
