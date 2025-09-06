#' @keywords internal
build_string <- function(mean_label = NULL,
                         mean_value = NULL,
                         cis = NULL,
                         stat_label,
                         stat_value,
                         pvalue,
                         full) {
  dplyr::case_when(full & !is.null(mean_label) & !is.null(mean_value) & !is.null(cis) ~
                     paste0(mean_label, mean_value, ", 95% CI [", cis[1], ", ",
                            cis[2], "], ", stat_label, " = ", stat_value, ", ", pvalue),
                   full & is.null(mean_label) & is.null(mean_value) & !is.null(cis) ~
                     paste0(stat_label, " = ", stat_value, ", 95% CI [", cis[1],
                            ", ", cis[2], "], ", pvalue),
                   full & !is.null(mean_label) & !is.null(mean_value) & is.null(cis) ~
                     paste0(mean_label, mean_value, ", ", stat_label, " = ", stat_value,
                            ", ", pvalue),
                   !full | (is.null(mean_label) & !is.null(mean_value) & !is.null(cis)) ~
                     paste0(stat_label, " = ", stat_value, ", ", pvalue))
}
