#' Launch underlying data documentation app
#'
#' @importFrom miniUI miniPage gadgetTitleBar miniTitleBarButton
#' @importFrom miniUI miniContentPanel
#' @importFrom shiny fillCol fillRow selectInput selectInput
#'
#' @return Nothing is returned, a shiny app is run
#'
#' @export doc_app
doc_app <- function() {
  ui <- miniUI::miniPage(
    miniUI::gadgetTitleBar(
      title = shiny::strong(shiny::code("raiden"), "data documentor"),
      left  = NULL,
      right = miniUI::miniTitleBarButton(
        inputId = "done",
        label = "Done",
        primary = TRUE)
    ),
    miniUI::miniContentPanel(
      shiny::fillCol(
        mod_obj_load_ui(id = "obj")
      )
    )
  )

  server <- function(input, output, session) {

    mod_obj_load_server(id = "obj")

  }

  shiny::shinyApp(ui, server)
}
