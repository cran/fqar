#' Obtain species details for a floristic quality assessment
#'
#' \code{assessment_inventory()} returns a data frame of all plant species
#' included in a floristic quality assessment obtained from
#' \href{https://universalfqa.org/}{universalfqa.org}.
#'
#' @param data_set A data set downloaded from
#'   \href{https://universalfqa.org/}{universalfqa.org} either manually or using
#'   \code{\link[=download_assessment]{download_assessment()}}.

#' @return A data frame with 9 columns:
#' \itemize{
#'    \item Scientific Name (character)
#'    \item Family (character)
#'    \item Acronym (character)
#'    \item Native? (character)
#'    \item C (numeric)
#'    \item W (numeric)
#'    \item Physiognomy (character)
#'    \item Duration (character)
#'    \item Common Name (character)
#' }
#'
#' @import dplyr tidyr
#' @importFrom rlang .data
#'
#' @examples
#' # While assessment_glance can be used with a .csv file downloaded
#' # manually from the universal FQA website, it is most typically used
#' # in combination with download_assessment().
#'
#' edison <- download_assessment(25002)
#' assessment_inventory(edison)
#'
#' @export

assessment_inventory <- function(data_set) {

  if (!is.data.frame(data_set)) {
    stop("data_set must be a dataframe obtained from the universalFQA.org website. Type ?download_assessment for help.", call. = FALSE)
  }
  if (!("Species Richness:" %in% data_set[[1]])) {
    stop("data_set must be a dataframe obtained from the universalFQA.org website. Type ?download_assessment for help.", call. = FALSE)
  }

  if (ncol(data_set) == 1) {

    new <- rbind(names(data_set), data_set)

    data_set <- separate(new,
                         col = 1,
                         sep = ",",
                         into = paste0("V", 1:9),
                         fill = "right")
  }

  data_set <- na_if(data_set, "n/a")
  data_set <- na_if(data_set, "")

  renamed <- data_set |>
    rename("Scientific Name" = 1,
           "Family" = 2,
           "Acronym" = 3,
           "Native?" = 4,
           "C" = 5,
           "W" = 6,
           "Physiognomy" = 7,
           "Duration" = 8,
           "Common Name" = 9)

  new <- renamed |>
    filter(row_number() > which(.data$`Scientific Name` == "Scientific Name"))
  new <- suppressWarnings(mutate(new, across(5:6, as.numeric)))

  class(new) <- c("tbl_df", "tbl", "data.frame")

  new
}
