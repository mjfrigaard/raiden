#' Gather all objects in global environment
#'
#' @return all objects in local environment
#'
#' @export gather_all
#'
#' @importFrom rlang global_env
#'
#' @examples
#' # f <- function() "top level function"
#' # gather_all()
gather_all <- function() {
  names(rlang::global_env())
}

#' Gather data.frames in global environment
#'
#' @return character vector of `data.frame`s in local environment
#'
#' @importFrom purrr map_chr
#' @importFrom rlang global_env
#'
#' @export gather_dfs
#'
#' @examples
#' # mtcars <- datasets::mtcars
#' # attitude <- datasets::attitude
#' # titanic <- datasets::Titanic
#' # gather_dfs()
gather_dfs <- function() {
  all_objects <- names(rlang::global_env())
  dfs <- purrr::map_chr(
    .x = all_objects,
    .f = \(x) if (is.data.frame(get(x))) {
      x
    } else {
      NA
    }
  )
  dfs[!is.na(dfs)]
}

#' Gather lists in global environment
#'
#' @return character vector of `list`s in local environment
#'
#' @export gather_lists
#'
#' @importFrom purrr map_chr
#' @importFrom rlang global_env
#'
#' @examples
#' # my_list <- list('mtcars' = datasets::mtcars,
#'                 'attitude' = datasets::attitude,
#'                 'titanic' = datasets::Titanic)
#' # gather_lists()
gather_lists <- function() {
  all_objects <- names(rlang::global_env())
  lists <- purrr::map_chr(
    .x = all_objects,
    .f = \(x) if (is.list(get(x)) & !is.data.frame(get(x))) {
      x
    } else {
      NA
    }
  )
  lists[!is.na(lists)]
}

#' Gather R6 objects in global environment
#'
#' @return character vector of `R6`s in local environment
#'
#' @export gather_r6s
#'
#' @importFrom R6 R6Class is.R6
#' @importFrom rlang global_env
#'
#' @examples
#' require(R6)
#' # class_generator <- R6::R6Class()
#' # object <- class_generator$new()
#' # gather_r6s()
gather_r6s <- function() {
  all_objects <- names(rlang::global_env())
  r6s <- purrr::map_chr(
    .x = all_objects,
    .f = \(x) if (R6::is.R6(get(x))) {
      x
    } else {
      NA
    }
  )
  r6s[!is.na(r6s)]
}

#' Gather objects in global environment
#'
#' @return all objects in local environment
#'
#' @export gather_objects
#'
#' @examples
#' require(R6)
#' my_list <- list('mtcars' = datasets::mtcars,
#'                 'attitude' = datasets::attitude,
#'                 'titanic' = datasets::Titanic)
#' mtcars <- datasets::mtcars
#' class_generator <- R6Class()
#' object <- class_generator$new()
#' gather_objects(type = "all")
gather_objects <- function(type = "all") {
  x <- switch(EXPR = type,
    all = gather_all(),
    data.frame = gather_dfs(),
    lists = gather_lists(),
    R6 = gather_r6s()
    )
  x[x != ".Random.seed"]
}
