
<!-- README.md is generated from README.Rmd. Please edit that file -->

# bqschol

<!-- badges: start -->
<!-- badges: end -->

The goal of bqschol is to provide an interface to SUB Göttingen’s big
scholarly datasets stored on Google Big Query.

This package is of internal use.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("njahn82/bqschol")
```

## Initialize the connection

Connect to dataset with Unpaywall snapshots

``` r
library(bqschol)
my_con <- bqschol::bgschol_con(
  dataset = "cr_history",
  path = "~/hoad-private-key.json")
```

You need to have a service account token to make use of this package!

## Table functions

The package provides wrapper for the most common table operations

-   `bgschol_list()`: List tables
-   `bgschol_tbl()`: Access tables with
-   `bgschol_query()`: Perform of a SQL query and retrieve results
-   `bgschol_execute()`: Execute a SQL query on the database

Let’s start by listing all Crossref snapshots on SUB Göttingen’s Big
Query project

``` r
bgschol_list(my_con)
#> [1] "cr_apr18" "cr_apr19" "cr_apr20" "cr_apr21"
```

We can determine the top publisher by type as of April 2018. Note that
we only stored Crossref records published later than 2007.

``` r
cr_instant_df <- bgschol_tbl(my_con, table = "cr_apr18")
cr_instant_df %>%
    #top publishers
    dplyr::group_by(publisher) %>%
    dplyr::summarise(n = dplyr::n_distinct(doi)) %>%
    dplyr::arrange(desc(n)) 
#> Complete
#> Billed: 0 B
#> Downloading 11 rows in 1 pages.
#> # Source:     lazy query [?? x 2]
#> # Database:   BigQueryConnection
#> # Ordered by: desc(n)
#>    publisher                                                      n
#>    <chr>                                                      <int>
#>  1 Elsevier BV                                              3613095
#>  2 Springer Nature                                          1680261
#>  3 Wiley-Blackwell                                           971562
#>  4 Informa UK Limited                                        770043
#>  5 Oxford University Press (OUP)                             387805
#>  6 SAGE Publications                                         352648
#>  7 Ovid Technologies (Wolters Kluwer Health)                 307476
#>  8 Institute of Electrical and Electronics Engineers (IEEE)  259231
#>  9 American Chemical Society (ACS)                           254027
#> 10 Royal Society of Chemistry (RSC)                          223431
#> # … with more rows
```

For more complex tasks, we use SQL.

``` r
cc_query <- c("SELECT
  publisher,
  COUNT(DISTINCT(DOI)) AS n
FROM
  `api-project-764811344545.cr_history.cr_apr18`,
  UNNEST(license) AS license
WHERE
  REGEXP_CONTAINS(license.URL, 'creativecommons')
GROUP BY
  publisher
ORDER BY
  n DESC
LIMIT
  10")
bgschol_query(my_con, cc_query)
#> Complete
#> Billed: 0 B
#> Downloading 10 rows in 1 pages.
#> # A tibble: 10 × 2
#>    publisher                                 n
#>    <chr>                                 <int>
#>  1 Elsevier BV                          330609
#>  2 Public Library of Science (PLoS)     163268
#>  3 MDPI AG                              121331
#>  4 Hindawi Limited                      119527
#>  5 Springer Nature                       97161
#>  6 IOP Publishing                        78405
#>  7 Scientific Research Publishing, Inc,  53984
#>  8 Walter de Gruyter GmbH                50288
#>  9 Copernicus GmbH                       32547
#> 10 Dove Medical Press Ltd.               26223
```

`bgschol_execute()` is when new tables shall be created or dropped in
Big Query.
