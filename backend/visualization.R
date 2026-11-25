library(ggplot2)

theme_eda_dark <- function() {
  theme_minimal(base_size = 12) +
    theme(
      plot.background = element_rect(fill = "#1e293b", color = NA),
      panel.background = element_rect(fill = "#0f172a", color = "#334155"),
      panel.grid.major = element_line(color = "#1e293b", linewidth = 0.5),
      panel.grid.minor = element_blank(),
      text = element_text(color = "#e2e8f0"),
      axis.text = element_text(color = "#94a3b8", size = 10),
      axis.title = element_text(color = "#cbd5e1", face = "bold", size = 11),
      plot.title = element_text(color = "#f8fafc", face = "bold", size = 13, margin = margin(b = 10)),
      legend.background = element_rect(fill = "#1e293b", color = NA),
      legend.text = element_text(color = "#cbd5e1"),
      legend.title = element_text(color = "#f8fafc", face = "bold")
    )
}

plot_numeric_distribution <- function(df, col_name, plot_type = "histogram") {
  clean_df <- df[!is.na(df[[col_name]]), , drop = FALSE]
  if (nrow(clean_df) == 0) return(NULL)
  
  if (plot_type == "boxplot") {
    ggplot(clean_df, aes(x = "", y = .data[[col_name]])) +
      geom_boxplot(fill = "#38bdf8", color = "#e0f2fe", alpha = 0.75, outlier.color = "#fb7185", outlier.size = 2.5) +
      coord_flip() +
      labs(title = paste("Boxplot Distribusi:", col_name), x = "", y = col_name) +
      theme_eda_dark()
  } else {
    ggplot(clean_df, aes(x = .data[[col_name]])) +
      geom_histogram(bins = 25, fill = "#6366f1", color = "#1e293b", alpha = 0.85) +
      geom_vline(aes(xintercept = mean(.data[[col_name]], na.rm = TRUE)), color = "#fbbf24", linetype = "dashed", linewidth = 1) +
      labs(title = paste("Histogram Distribusi:", col_name, "(Garis Kuning = Mean)"), x = col_name, y = "Frekuensi") +
      theme_eda_dark()
  }
}

plot_categorical_bar <- function(df, col_name, top_n = 10) {
  vec <- df[[col_name]]
  vec <- vec[!is.na(vec) & trimws(as.character(vec)) != ""]
  if (length(vec) == 0) return(NULL)
  
  freq_df <- as.data.frame(sort(table(vec), decreasing = TRUE))
  colnames(freq_df) <- c("Kategori", "Jumlah")
  freq_df <- head(freq_df, top_n)
  
  ggplot(freq_df, aes(x = reorder(Kategori, Jumlah), y = Jumlah)) +
    geom_col(fill = "#f43f5e", alpha = 0.85, width = 0.65) +
    geom_text(aes(label = Jumlah), hjust = -0.2, color = "#f8fafc", size = 3.5) +
    coord_flip() +
    scale_y_continuous(expand = expansion(mult = c(0, 0.15))) +
    labs(title = paste("Top Kategori:", col_name), x = "", y = "Frekuensi") +
    theme_eda_dark()
}

plot_correlation_heatmap <- function(df, num_cols) {
  if (length(num_cols) < 2) return(NULL)
  
  num_df <- df[, num_cols, drop = FALSE]
  cor_mat <- round(cor(num_df, use = "pairwise.complete.obs"), 2)
  
  cor_long <- expand.grid(Var1 = rownames(cor_mat), Var2 = colnames(cor_mat), stringsAsFactors = FALSE)
  cor_long$Value <- as.vector(cor_mat)
  
  ggplot(cor_long, aes(x = Var1, y = Var2, fill = Value)) +
    geom_tile(color = "#0f172a", linewidth = 0.8) +
    geom_text(aes(label = Value), color = "#f8fafc", size = 3.5, fontface = "bold") +
    scale_fill_gradient2(low = "#f43f5e", mid = "#1e293b", high = "#10b981", midpoint = 0, limits = c(-1, 1)) +
    labs(title = "Matriks Korelasi Pearson (Variabel Numerik)", x = "", y = "", fill = "Korelasi") +
    theme_eda_dark() +
    theme(axis.text.x = element_text(angle = 35, hjust = 1))
}
