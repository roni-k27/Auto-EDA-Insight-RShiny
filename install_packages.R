# Skrip Instalasi Dependensi Paket R - Auto EDA Insight Platform
required_packages <- c(
  "shiny",
  "shinydashboard",
  "DT",
  "readxl",
  "ggplot2"
)

install_if_missing <- function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    message(paste("Menginstal paket:", pkg))
    install.packages(pkg, dependencies = TRUE, repos = "https://cloud.r-project.org/")
  } else {
    message(paste("Paket sudah terinstal:", pkg))
  }
}

invisible(lapply(required_packages, install_if_missing))
message("Semua dependensi berhasil diperiksa dan siap digunakan!")
