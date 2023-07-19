#' Launch raiden addin
#'
#' Launch the `raidenApp()` Addin to document your R object. For more
#' information on `.rs.invokeShinyPaneViewer`, see
#' [this SO post](https://stackoverflow.com/questions/35311318/opening-shiny-app-directly-in-the-default-browser)
#'
#' @export raidenApp
#'
#' @importFrom withr local_options
#'
raidenApp <- function() {
  withr::local_options(shiny.launch.browser = ".rs.invokeShinyPaneViewer")
  docApp()
}

#' Underlying data documentation app
#'
#' @importFrom miniUI miniPage gadgetTitleBar miniTitleBarButton
#' @importFrom miniUI miniContentPanel
#' @importFrom shiny fillCol fillRow selectInput selectInput
#'
#' @return Nothing is returned, a shiny app is run
#'
#' @export
docApp <- function() {
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
        shiny::fillRow(
          shiny::fillCol(
            flex = c(1, 1, 1.5, 2, 1),
            shiny::fillRow(
              shiny::selectInput(
                inputId = "object",
                label   = "Select object",
                choices = NULL,
                width   = "90%"
              ),
              shiny::selectInput(
                inputId = "roxygen_type",
                label = "Select roxygen2 type",
                choices = c("data.frame", "list", "vector", "R6"),
                width = "90%"
              )
            )
          ),
          shiny::column(
            width = 12,
            shiny::textAreaInput(
              inputId = "title",
              label = "Object title",
              value = "#' ",
              rows = 2,
              width = "100%"
            )
          )
        )
      )
    )
  )

  server <- function(input, output, session) {

    all_objects <- shiny::reactive(gather_objects())

    shiny::observe(
      shiny::updateSelectInput(
        session = session,
        inputId = "object",
        choices = all_objects()
      )
    )

  #
  #   prepped_prompt <- shiny::reactive({
  #     shiny::req(nchar(input$dataframes) > 0)
  #     prep_data_prompt(
  #       get(sym(input$dataframes)),
  #       method = input$sum_method,
  #       prompt = "Create a roxygen skeleton to document this data. Include at
  #     least `title`, `format`, and `describe` fields. Provide range, number of
  #     missing values, and type for each column in the data frame. Follow
  #     roxygen2 conventions:\n\n"
  #     )
  #   })


  #   shiny::observe({
  #     cli_inform("Updating prompt")
  #     shiny::updateTextAreaInput(
  #       session = session,
  #       inputId = "prompt",
  #       value = prepped_prompt()
  #     )
  #   }) |>
  #     shiny::bindEvent(input$update_prompt)
  #
  #   shiny::observe({
  #     cli_inform(c("i" = "Querying OpenAI's API..."))
  #     interim <- openai_create_completion(
  #       model = "text-davinci-003",
  #       prompt = input$prompt,
  #       temperature = input$temperature,
  #       max_tokens = input$max_tokens,
  #       openai_api_key = Sys.getenv("OPENAI_API_KEY")
  #     )
  #
  #     cli_inform(c("i" = "Response received. Providng output text."))
  #     output$response <- shiny::renderText(interim$choices[1, 1])
  #   }) |>
  #     shiny::bindEvent(input$query_gpt)
  #
  #   shiny::observe(shiny::stopApp()) |> shiny::bindEvent(input$done)
  }

  shiny::shinyApp(ui, server)
}
