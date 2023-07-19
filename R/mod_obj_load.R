#' Load objects module UI
#'
#' @param id module id
#'
#' @return UI module function
#' @export
#'
mod_obj_load_ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::tagList(
        shiny::fillRow(
          shiny::fillCol(
            flex = c(1, 1, 1.5, 2, 1),
            shiny::fillRow(
              shiny::selectInput(
                inputId = ns("object"),
                label   = "Select object",
                choices = NULL,
                width   = "90%"
              ),
              shiny::selectInput(
                inputId = ns("class"),
                label = "Select class",
                choices = NULL,
                width = "90%"
              )
            )
          ),
          shiny::column(
            width = 12,
            shiny::textAreaInput(
              inputId = ns("title"),
              label = "Object title",
              value = "#' ",
              rows = 2,
              width = "100%"
            )
          )
        )
  )
}

#' Load objects module server
#'
#' @param id module id
#'
#' @return server module function
#' @export
#'
mod_obj_load_server <- function(id) {

    shiny::moduleServer(id, function(input, output, session) {
        ns <- session

    all_objects <- shiny::reactive(gather_objects())
    all_classes <- shiny::reactive(gather_classes())

    shiny::observe(
      shiny::updateSelectInput(
        session = session,
        inputId = "object",
        choices = all_objects()
      )
    )
    shiny::observe(
      shiny::updateSelectInput(
        session = session,
        inputId = "class",
        choices = unname(all_classes())
      )
    ) |>
      shiny::bindEvent(all_classes(),
        ignoreNULL = TRUE)

    return(
      shiny::reactive({
        list(
          objects = gather_objects(),
          classe = gather_classes()
        )
      })
    )

    })



}
