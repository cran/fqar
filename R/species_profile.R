#' Generate the co-occurrence profile for a species
#'
#' \code{species_profile()} accepts a species and list of inventories like those
#' generated by
#' \code{\link[=assessment_list_inventory]{assessment_list_inventory()}} and
#' returns the co-occurrence profile of that species. Repeated co-occurrences
#' across multiple assessments are included in summary calculations but self
#' co-occurrences are not.
#'
#' @param species The scientific name of the target plant species
#' @param inventory_list A list of site inventories having the format of
#' \code{\link[=assessment_list_inventory]{assessment_list_inventory()}}
#' @param native Logical indicating whether only native co-occurrences should be
#'   considered.
#'
#' @return A data frame with 14 columns:
#' \itemize{
#' \item target_species (character)
#' \item target_species_c (numeric)
#' \item cospecies_n (numeric)
#' \item cospecies_native_n (numeric)
#' \item cospecies_mean_c (numeric)
#' \item cospecies_native_mean_c  (numeric)
#' \item cospecies_std_dev_c  (numeric)
#' \item cospecies_native_std_dev_c  (numeric)
#' \item percent_native  (numeric)
#' \item percent_nonnative (numeric)
#' \item percent_native_low_c (numeric)
#' \item percent_native_med_c  (numeric)
#' \item percent_native_high_c  (numeric)
#' \item discrepancy_c (numeric)
#' }
#'
#' @import dplyr
#' @importFrom rlang .data
#' @importFrom stats sd
#'
#' @examples
#' # species_profile() is best used in combination with
#' # download_assessment_list() and assessment_list_inventory().
#'
#' \donttest{
#' ontario <- download_assessment_list(database = 2)
#' ontario_invs <- assessment_list_inventory(ontario)
#' species_profile("Aster lateriflorus", ontario_invs)
#' }
#'
#' @export


species_profile <-
  function(species, inventory_list, native = FALSE) {
    if (!is_inventory_list(inventory_list)) {
      message(
        "assessment_list must be a list of dataframes obtained from universalFQA.org. Type ?download_assessment_list for help.")
      return(invisible(NULL))
    }

    included <- vector("logical")
    for (inventory in seq_along(inventory_list)) {
      included[inventory] <-
        (species %in% inventory_list[[inventory]]$scientific_name)
    } # gives a logical vector indicating which inventories include the given species

    if (sum(included) == 0) {
      stop("Species does not appear in any assessment. No profile generated.",
           call. = FALSE)
    }

    short_list <-
      inventory_list[included] # all of these should include the species now
    cooccur_df <- do.call(rbind, short_list)

    species_only <- dplyr::filter(cooccur_df,
                                  .data$scientific_name == species)
    target_c <- species_only$c[1] # record target species c-value.
    cooccur_df <- dplyr::filter(cooccur_df,
                                .data$scientific_name != species)

    if (native == TRUE) {
      cooccur_df <- dplyr::filter(cooccur_df,
                                  .data$nativity == "native")
    }

    cooccur <- dplyr::mutate(cooccur_df,
                             as.factor(.data$c))

    c_counts <- cooccur |>
      dplyr::group_by(c) |>
      dplyr::count()

    missing_fill <- data.frame(c = 0:10, n = 0)
    missing_fill <- dplyr::anti_join(missing_fill,
                                     c_counts,
                                     by = "c")
    c_counts <- rbind(c_counts, missing_fill)
    c_counts |>
      dplyr::arrange(c) |>
      dplyr::ungroup() |>
      dplyr::mutate(species, target_c) |>
      dplyr::select(species,
                    target_c,
                    cospecies_c = c,
                    cospecies_n = n)

  }
