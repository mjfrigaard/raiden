#' Launch raiden addin
#'
#' Launch the `raidenApp()` Addin to document your R object. For more
#' information on `.rs.invokeShinyPaneViewer`, see
#' [this SO post](https://bit.ly/44QNM1z)
#'
#' @export raiden_app
#'
#' @importFrom withr local_options
#'
raiden_app <- function() {
  withr::local_options(shiny.launch.browser = ".rs.invokeShinyPaneViewer")
  doc_app()
}
