library(readxl)
library(tools)

load_and_detect_data <- function(file_path, filename) {
  ext <- tolower(file_ext(filename))
  
  if (ext == "csv") {
    first_line <- readLines(file_path, n = 1, warn = FALSE)
    sep_char <- if (length(first_line) > 0 && grepl(";", first_line)) ";" else ","
    df <- read.csv(file_path, sep = sep_char, stringsAsFactors = FALSE, na.strings = c("", "NA", "N/A", "null", "NULL"))
  } else if (ext %in% c("xlsx", "xls")) {
    df <- as.data.frame(read_excel(file_path))
  } else if (ext == "txt") {
    df <- read.delim(file_path, stringsAsFactors = FALSE, na.strings = c("", "NA", "N/A", "null", "NULL"))
  } else {
    stop("Format file tidak didukung! Gunakan .csv, .xlsx, .xls, atau .txt.")
  }
  
  if (nrow(df) == 0 || ncol(df) == 0) {
    stop("Dataset kosong atau tidak memiliki kolom yang valid.")
  }
  
  num_cols <- names(df)[sapply(df, is.numeric)]
  cat_cols <- names(df)[sapply(df, function(x) is.character(x) || is.factor(x) || is.logical(x))]
  date_cols <- names(df)[sapply(df, function(x) inherits(x, "Date") || inherits(x, "POSIXt"))]
  
  total_cells <- nrow(df) * ncol(df)
  total_missing <- sum(is.na(df))
  duplicate_rows <- sum(duplicated(df))
  
  return(list(
    df = df,
    num_cols = num_cols,
    cat_cols = cat_cols,
    date_cols = date_cols,
    info = list(
      filename = filename,
      file_size = paste0(round(file.info(file_path)$size / 1024, 2), " KB"),
      total_rows = nrow(df),
      total_cols = ncol(df),
      numeric_count = length(num_cols),
      categorical_count = length(cat_cols),
      datetime_count = length(date_cols),
      total_missing = total_missing,
      missing_pct = round((total_missing / total_cells) * 100, 2),
      duplicate_rows = duplicate_rows
    )
  ))
}
