#' Check .Rproj file for package fields
#'
#' @return logical (TRUE if package fields are present)
#'
#' @export
#'
#' @examples
#' check_rproj()
check_rproj <- function() {
  proj_file <- list.files(path = getwd(),
                          pattern = ".Rproj",
                          full.names = TRUE)
  if (length(proj_file) > 0) {
    proj_contents <- readLines(proj_file)
  }
  any(grepl(pattern = "BuildType: Package", x = proj_contents))
}
#' Check DESCRIPTION file for package fields
#'
#' @return logical (TRUE if package fields are present)
#'
#' @export
#'
#' @examples
#' check_desc()
check_desc <- function() {
  desc_file <- list.files(path = getwd(),
                          pattern = "DESCRIPTION",
                          full.names = TRUE)
  if (length(desc_file) > 0) {
    desc_contents <- readLines(desc_file)
  }

any(grepl(pattern = "Package: |Type: Package", x = desc_contents))

}
#' Check DESCRIPTION and .Rproj files for package fields
#'
#' @return logical (TRUE if package files/fields are present)
#'
#' @export
#'
#' @examples
#' is_package()
is_package <- function() {
  # check project
  proj <- check_rproj()
  # check description
  desc <- check_desc()
  if (any(proj, desc)) {
    TRUE
  } else {
    FALSE
  }
}
