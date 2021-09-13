#' Create connection
#'
#' Authorization is only possible through a service account token. 
#' The toke can be requested from Najko
#' <mailto:najko.jahn@sub.uni-goettingen.de>
#'
#' @param dataset big scholarly datasets. Currently the 
#'  following datasets are availabe:
#'  - *cr_instant* Most recent monthly Crossref metadata snapshot,
#'    comprising metadata about journal articles published since 2008.
#'  - *cr_history* Historic Crossref metadata snapshots starting Apr
#'    2018.
#'  - *oadoi_full* Unpaywall metadata since 2008.
#'
#' @param path Path to JSON identifying the associated service account.
#' @export
bgschol_con <- function(dataset = "cr_instant", path = NULL) {
    # authorize through service account
    bgschol_auth(path = path)
    # check if dataset is available
    stopifnot(
        bigrquery::bq_dataset_exists(
            bgschol_dataset(dataset = dataset)
            )
        )
    # create DBI connection
    DBI::dbConnect(bigrquery::bigquery(),
                   project = bgschol_project_id(),
                   dataset = dataset)
}


#' Authorize connection
#'
#' Authorize bigrquery to view and manage big scholarly databases
#' on Google Big Query maintained by SUB Göttingen. Authorization
#' is only possible through a service account token. It can be
#' requested from Najko <mailto:najko.jahn@sub.uni-goettingen.de>
#'
#'
#' @noRd
bgschol_auth <- function(path = NULL) {
    if (is.null(path))
        bigrquery::bq_auth(path = bgschol_service_account())
    else
        bigrquery::bq_auth(path = path)
}

#' Path to JSON identifying the associated service account
#'
#' @noRd
bgschol_service_account <- function() "~/hoad-private-key.json"

#' Database project
#'
#' @noRd
bgschol_project_id <- function() "api-project-764811344545"

#' Create reference to Big Query datasets.
#'
#' @noRd
bgschol_dataset <- function(project = bgschol_project_id(),
    dataset = dataset) {
    bigrquery::bq_dataset(bgschol_project_id(), dataset = dataset)
}