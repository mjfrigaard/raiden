injectHighlightHandler <- function() {

 code <- "
  Shiny.addCustomMessageHandler('highlight-code', function(message) {
    var id = message['id'];
    setTimeout(function() {
      var el = document.getElementById(id);
      hljs.highlightBlock(el);
    }, 100);
  });
  "

 tags$script(code)
}

includeHighlightJs <- function() {
 resources <- system.file("www/shared/highlight", package = "shiny")
 list(includeScript(file.path(resources, "highlight.pack.js")),
  includeCSS(file.path(resources, "rstudio.css")), injectHighlightHandler())
}

highlightCode <- function(session, id) {
 session$sendCustomMessage("highlight-code", list(id = id))
}

rCodeContainer <- function(...) {
 code <- HTML(as.character(tags$code(class = "language-r",
  ...)))
 div(pre(code))
}

renderCode <- function(expr, env = parent.frame(), quoted = FALSE) {
 func <- NULL
 installExprFunction(expr, "func", env, quoted)
 markRenderFunction(textOutput, function() {
  paste(func(), collapse = "\n")
 })
}

stableColumnLayout <- function(...) {
 dots <- list(...)
 n <- length(dots)
 width <- 12/n
 class <- sprintf("col-xs-%s col-md-%s", width, width)
 fluidRow(lapply(dots, function(el) {
  div(class = class, el)
 }))
}

isErrorMessage <- function(object) {
 inherits(object, "error_message")
}

errorMessage <- function(type, message) {
 structure(list(type = type, message = message), class = "error_message")
}


#' Reformat a block of code using formatR.
reformatAddin <- function() {

 formatRLink <- tags$a(href = "http://yihui.name/formatR/",
  "formatR")

 ui <- miniPage(includeHighlightJs(), gadgetTitleBar("Reformat Code"),
  miniContentPanel(h4("Use ", formatRLink, " to reformat code."),
   hr(), stableColumnLayout(checkboxInput("brace.newline",
    "Place left braces '{' on a new line?", FALSE),
    numericInput("indent", "Indent size: ", 2), numericInput("width",
      "Column width: ", 60)), uiOutput("document",
    container = rCodeContainer)))

 server <- function(input, output, session) {

  # Get the document context.
  context <- rstudioapi::getActiveDocumentContext()

  reactiveDocument <- reactive({

   # Collect inputs
   brace.newline <- input$brace.newline
   indent <- input$indent
   width <- input$width

   # Build formatted document
   formatted <- formatR::tidy_source(text = context$contents,
    output = FALSE, width.cutoff = width, indent = indent,
    brace.newline = brace.newline)$text.tidy

   formatted
  })

  output$document <- renderCode({
   document <- reactiveDocument()
   highlightCode(session, "document")
   document
  })

  observeEvent(input$done, {
   contents <- paste(reactiveDocument(), collapse = "\n")
   rstudioapi::setDocumentContents(contents, id = context$id)
   invisible(stopApp())
  })

 }

 viewer <- dialogViewer("Reformat Code", width = 1000, height = 800)

 runGadget(ui, server, viewer = viewer)

}

reformatAddin()
