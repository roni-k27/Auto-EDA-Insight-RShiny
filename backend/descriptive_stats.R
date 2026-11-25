calculate_basic_stats <- function(df, numerical_cols, categorical_cols) {
  stats_summary <- list(numerical = list(), categorical = list())
  
  for (col in numerical_cols) {
    vec <- df[[col]]
    n_miss <- sum(is.na(vec))
    clean_vec <- vec[!is.na(vec)]
    
    if (length(clean_vec) > 0) {
      q1 <- as.numeric(quantile(clean_vec, 0.25, names = FALSE))
      q3 <- as.numeric(quantile(clean_vec, 0.75, names = FALSE))
      iqr_val <- q3 - q1
      lower_bound <- q1 - 1.5 * iqr_val
      upper_bound <- q3 + 1.5 * iqr_val
      n_outliers <- sum(clean_vec < lower_bound | clean_vec > upper_bound)
      
      stats_summary$numerical[[col]] <- list(
        mean = round(mean(clean_vec), 2),
        sd = round(sd(clean_vec), 2),
        median = round(median(clean_vec), 2),
        q1 = round(q1, 2),
        q3 = round(q3, 2),
        min = round(min(clean_vec), 2),
        max = round(max(clean_vec), 2),
        outliers = n_outliers,
        missing_values = n_miss,
        missing_percentage = round((n_miss / nrow(df)) * 100, 2)
      )
    } else {
      stats_summary$numerical[[col]] <- list(
        mean = NA, sd = NA, median = NA, q1 = NA, q3 = NA,
        min = NA, max = NA, outliers = 0,
        missing_values = n_miss,
        missing_percentage = 100
      )
    }
  }
  
  for (col in categorical_cols) {
    vec <- df[[col]]
    n_miss <- sum(is.na(vec) | trimws(as.character(vec)) == "")
    valid_vec <- vec[!is.na(vec) & trimws(as.character(vec)) != ""]
    freq_table <- sort(table(valid_vec), decreasing = TRUE)
    
    stats_summary$categorical[[col]] <- list(
      unique_categories = length(unique(valid_vec)),
      mode = if (length(freq_table) > 0) names(freq_table)[1] else "N/A",
      mode_frequency = if (length(freq_table) > 0) as.integer(freq_table[1]) else 0,
      mode_percentage = if (length(freq_table) > 0 && length(valid_vec) > 0) round((as.integer(freq_table[1]) / length(valid_vec)) * 100, 1) else 0,
      missing_values = n_miss,
      missing_percentage = round((n_miss / nrow(df)) * 100, 2)
    )
  }
  
  return(stats_summary)
}
