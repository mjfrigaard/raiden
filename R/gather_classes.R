#' Squish `class()`
#'
#' @param x object
#'
#' @return class as `length(x) == 1`
#'
#' @export squish_class
#'
#' @examples
#' squish_class(Sys.time())
squish_class <- function(x) {
  if (length(class(x)) > 1) {
    paste0(class(x), collapse = ", ")
  } else {
    class(x)
  }
}

#' Gather object classes from global environment
#'
#' @return named vector of class and object
#'
#' @importFrom purrr map_chr set_names
#'
#' @export gather_classes
#'
gather_classes <- function() {
  all_objects <- gather_objects(type = "all")
  obj_types <- purrr::map_chr(
    .x = all_objects,
    .f = \(x) squish_class(get(x)))
  # drop gather_types from all objects
  all_objects[all_objects != "gather_types"]
  # drop closure from object types
  obj_types[obj_types != "closure"]
  if (length(obj_types) == length(all_objects)) {
    purrr::set_names(x = obj_types, nm = all_objects)
  }
}
