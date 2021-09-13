#' Get a list of tables
#'
#' List of tables for big scholarly dataset.
#'
#' @param con bgschol_con connection ([bgschol_con()])
#'
#' @examples
#' \dontrun{
#' # Connect
#' my_con <- my_con <- bqschol::bgschol_con(dataset = "cr_history")
#' # Get a list of tables
#' bgschol_list(my_con)
#' }
#' @export
bgschol_list <- function(con = NULL) {
    stopifnot(DBI::dbIsValid(con))
    DBI::dbListTables(con)
}

#' Access a single table with dpylr
#'
#' dplyr interface treats tables as if they are in-memory data frames.
#' This enables accessing  big scholarly dataset without SQL.
#'
#' @param con bgschol_con connection ([bgschol_con()])
#' @param table Database table
#' 
#' @examples
#' \dontrun{
#' my_con <- bqschol::bgschol_con()
#' cr_instant_df <- bgschol_tbl(my_con, table = "snapshot")
#' cr_instant_df %>%
#'     #top publishers
#'     dplyr::group_by(publisher) %>%
#'     dplyr::summarise(n = dplyr::n_distinct(doi)) %>%
#'     dplyr::arrange(desc(n)) %>%
#'     # Compute query and download to local session
#'     dplyr::collect()
#'    }
#' @export
bgschol_tbl <- function(con = NULL, table = NULL) {
    stopifnot(DBI::dbIsValid(con))
    dplyr::tbl(con, table)
}
#' Perform a SQL query and retrieve result
#' 
#' Wrapper for DBI::dbGetQuery
#' 
#' @param con bgschol_con connection ([bgschol_con()])
#' @param query SQL string
#' 
#' @export
bgschol_query <- function(con = NULL, query = NULL) {
    stopifnot(DBI::dbIsValid(con))
    DBI::dbGetQuery(con, query)
}
#' Execute a SQL query on the database
#'
#' Returns a scalar numeric that specifies the number of rows 
#' affected by the statement.
#'
#' Wrapper for DBI::dbGetQuery
#'
#' @param con bgschol_con connection ([bgschol_con()])
#' @param query SQL string
#'
#' @export
bgschol_execute <- function(con = NULL, query = NULL) {
    stopifnot(DBI::dbIsValid(con))
    DBI::dbGetQuery(con, query)
}
