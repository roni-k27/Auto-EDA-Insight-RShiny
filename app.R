library(shiny)
library(shinydashboard)
library(DT)
library(readxl)
library(ggplot2)

source("backend/data_loader.R")
source("backend/descriptive_stats.R")
source("backend/visualization.R")

ui <- dashboardPage(
  skin = "black",
  dashboardHeader(title = "Auto EDA Platform", titleWidth = 260),
  dashboardSidebar(
    width = 260,
    sidebarMenu(
      id = "tabs",
      menuItem("Upload Dataset", tabName = "upload_tab", icon = icon("cloud-upload-alt")),
      menuItem("Dashboard Analitik", tabName = "dashboard_tab", icon = icon("chart-pie")),
      menuItem("Visualisasi & Korelasi", tabName = "viz_tab", icon = icon("chart-bar"))
    )
  ),
  dashboardBody(
    tags$head(
      tags$script(src = "https://cdn.tailwindcss.com"),
      tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
    ),
    tabItems(
      # TAB 1: UPLOAD DATASET
      tabItem(tabName = "upload_tab",
              div(class = "flex items-center justify-center min-h-[75vh]",
                  div(class = "w-full max-w-xl p-8 bg-slate-800 border border-slate-700 rounded-2xl shadow-2xl",
                      h2(class = "text-2xl font-bold text-white text-center mb-2", "Intelligent Data Analytics"),
                      p(class = "text-slate-400 text-sm text-center mb-6", "Unggah dataset Anda (.csv, .xlsx, .xls, .txt) atau gunakan dataset contoh bawaan."),
                      fileInput("file_input", "Pilih File dari Komputer", width = "100%", accept = c(".csv", ".xlsx", ".xls", ".txt")),
                      div(class = "space-y-3 mt-2",
                          actionButton("process_btn", "Mulai Ekstraksi Analitis", icon = icon("play"),
                                       class = "w-full bg-indigo-600 hover:bg-indigo-700 text-white font-semibold py-3 px-4 rounded-xl transition border-0"),
                          actionButton("sample_btn", "Gunakan Sample Dataset (Penjualan)", icon = icon("database"),
                                       class = "w-full bg-slate-700 hover:bg-slate-600 text-slate-200 font-medium py-2.5 px-4 rounded-xl transition border border-slate-600")
                      )
                  )
              )
      ),
      
      # TAB 2: DASHBOARD ANALITIK
      tabItem(tabName = "dashboard_tab",
              div(class = "flex flex-col md:flex-row md:items-center md:justify-between border-b border-slate-800 pb-5 mb-6 gap-4",
                  div(
                    h1(class = "text-2xl font-bold text-white tracking-tight", "Intelligent Data Analytics Dashboard"),
                    p(class = "text-slate-400 text-sm mt-1", "UAS Data Science Programming (SD-1306)")
                  ),
                  div(class = "flex items-center gap-3",
                      downloadButton("download_stats_btn", "Unduh Ringkasan (.csv)",
                                     class = "bg-emerald-600 hover:bg-emerald-700 text-white text-xs font-semibold py-2.5 px-4 rounded-xl border-0"),
                      div(class = "p-3 bg-slate-800/50 border border-slate-700 rounded-xl text-xs text-slate-400",
                          p(class = "font-semibold text-slate-300", "ITSB - Sains Data | Dosen: Bakti Siregar, M.Sc.")
                      )
                  )
              ),
              div(class = "grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5 mb-6",
                  uiOutput("card_rows_ui"), uiOutput("card_cols_ui"), uiOutput("card_num_ui"), uiOutput("card_cat_ui")
              ),
              uiOutput("data_quality_banner_ui"),
              div(class = "w-full bg-slate-800 border border-slate-700 rounded-2xl p-6 mb-6 shadow-sm",
                  h2(class = "text-base font-semibold text-white mb-4", "Data Preview (10 Baris Pertama)"),
                  div(class = "overflow-x-auto rounded-xl border border-slate-700", DTOutput("preview_table"))
              ),
              div(class = "grid grid-cols-1 lg:grid-cols-2 gap-6",
                  div(class = "bg-slate-800 border border-slate-700 rounded-2xl p-6 shadow-sm",
                      h2(class = "text-base font-semibold text-sky-400 mb-4", "Ringkasan Deskriptif Numerik"),
                      uiOutput("numeric_summary_ui")
                  ),
                  div(class = "bg-slate-800 border border-slate-700 rounded-2xl p-6 shadow-sm",
                      h2(class = "text-base font-semibold text-rose-400 mb-4", "Ringkasan Deskriptif Kategorikal"),
                      uiOutput("categorical_summary_ui")
                  )
              )
      ),
      
      # TAB 3: VISUALISASI & KORELASI
      tabItem(tabName = "viz_tab",
              div(class = "border-b border-slate-800 pb-5 mb-6",
                  h1(class = "text-2xl font-bold text-white tracking-tight", "Eksplorasi Visual & Korelasi"),
                  p(class = "text-slate-400 text-sm mt-1", "Distribusi variabel numerik, frekuensi kategori, dan hubungan antar-fitur.")
              ),
              div(class = "grid grid-cols-1 lg:grid-cols-2 gap-6 mb-6",
                  div(class = "bg-slate-800 border border-slate-700 rounded-2xl p-6 shadow-sm",
                      h2(class = "text-base font-semibold text-indigo-400 mb-4", "Distribusi Variabel Numerik"),
                      div(class = "grid grid-cols-1 sm:grid-cols-2 gap-3 mb-4",
                          selectInput("sel_num_col", "Pilih Kolom Numerik:", choices = NULL, width = "100%"),
                          selectInput("sel_num_type", "Jenis Grafik:", choices = c("Histogram" = "histogram", "Boxplot (Outlier)" = "boxplot"), width = "100%")
                      ),
                      plotOutput("num_dist_plot", height = "320px")
                  ),
                  div(class = "bg-slate-800 border border-slate-700 rounded-2xl p-6 shadow-sm",
                      h2(class = "text-base font-semibold text-rose-400 mb-4", "Frekuensi Variabel Kategorikal"),
                      div(class = "mb-4",
                          selectInput("sel_cat_col", "Pilih Kolom Kategorikal:", choices = NULL, width = "100%")
                      ),
                      plotOutput("cat_bar_plot", height = "320px")
                  )
              ),
              div(class = "w-full bg-slate-800 border border-slate-700 rounded-2xl p-6 shadow-sm",
                  h2(class = "text-base font-semibold text-emerald-400 mb-4", "Heatmap Korelasi Antar-Variabel Numerik"),
                  plotOutput("cor_heatmap_plot", height = "420px")
              )
      )
    )
  )
)

server <- function(input, output, session) {
  options(shiny.maxRequestSize = 16 * 1024^2)
  reactive_data <- reactiveValues(df = NULL, info = NULL, num_cols = NULL, cat_cols = NULL, stats = NULL)
  
  process_dataset <- function(file_path, file_name) {
    tryCatch({
      res <- load_and_detect_data(file_path, file_name)
      reactive_data$df <- res$df
      reactive_data$info <- res$info
      reactive_data$num_cols <- res$num_cols
      reactive_data$cat_cols <- res$cat_cols
      reactive_data$stats <- calculate_basic_stats(res$df, res$num_cols, res$cat_cols)
      
      updateSelectInput(session, "sel_num_col", choices = res$num_cols, selected = if (length(res$num_cols) > 0) res$num_cols[1] else NULL)
      updateSelectInput(session, "sel_cat_col", choices = res$cat_cols, selected = if (length(res$cat_cols) > 0) res$cat_cols[1] else NULL)
      
      showNotification(paste("Berhasil memuat:", file_name), type = "message", duration = 3)
      updateTabItems(session, "tabs", "dashboard_tab")
    }, error = function(e) {
      showNotification(paste("Gagal memproses file:", e$message), type = "error", duration = 6)
    })
  }
  
  observeEvent(input$process_btn, {
    if (is.null(input$file_input)) {
      showNotification("Silakan pilih file terlebih dahulu atau gunakan Sample Dataset.", type = "warning", duration = 4)
      return()
    }
    process_dataset(input$file_input$datapath, input$file_input$name)
  })
  
  observeEvent(input$sample_btn, {
    sample_path <- "data/raw/sample_sales_analytics.csv"
    if (file.exists(sample_path)) {
      process_dataset(sample_path, "sample_sales_analytics.csv")
    } else {
      showNotification("File sample dataset tidak ditemukan di data/raw/.", type = "error")
    }
  })
  
  output$card_rows_ui <- renderUI({
    val <- ifelse(is.null(reactive_data$info), 0, format(reactive_data$info$total_rows, big.mark = ","))
    div(class = "bg-slate-800 border border-slate-700 p-5 rounded-2xl flex items-center justify-between",
        div(p(class = "text-slate-400 text-xs font-semibold uppercase", "Total Baris Data"), h3(class = "text-2xl font-bold text-indigo-400 mt-1", val)),
        div(class = "p-3 bg-indigo-500/10 rounded-xl text-indigo-400", icon("list", class = "fa-2x")))
  })
  
  output$card_cols_ui <- renderUI({
    val <- ifelse(is.null(reactive_data$info), 0, reactive_data$info$total_cols)
    div(class = "bg-slate-800 border border-slate-700 p-5 rounded-2xl flex items-center justify-between",
        div(p(class = "text-slate-400 text-xs font-semibold uppercase", "Total Kolom"), h3(class = "text-2xl font-bold text-emerald-400 mt-1", val)),
        div(class = "p-3 bg-emerald-500/10 rounded-xl text-emerald-400", icon("columns", class = "fa-2x")))
  })
  
  output$card_num_ui <- renderUI({
    val <- ifelse(is.null(reactive_data$info), 0, reactive_data$info$numeric_count)
    div(class = "bg-slate-800 border border-slate-700 p-5 rounded-2xl flex items-center justify-between",
        div(p(class = "text-slate-400 text-xs font-semibold uppercase", "Kolom Numerik"), h3(class = "text-2xl font-bold text-amber-400 mt-1", val)),
        div(class = "p-3 bg-amber-500/10 rounded-xl text-amber-400", icon("calculator", class = "fa-2x")))
  })
  
  output$card_cat_ui <- renderUI({
    val <- ifelse(is.null(reactive_data$info), 0, reactive_data$info$categorical_count)
    div(class = "bg-slate-800 border border-slate-700 p-5 rounded-2xl flex items-center justify-between",
        div(p(class = "text-slate-400 text-xs font-semibold uppercase", "Kolom Kategorikal"), h3(class = "text-2xl font-bold text-pink-400 mt-1", val)),
        div(class = "p-3 bg-pink-500/10 rounded-xl text-pink-400", icon("font", class = "fa-2x")))
  })
  
  output$data_quality_banner_ui <- renderUI({
    req(reactive_data$info)
    info <- reactive_data$info
    div(class = "bg-slate-800/80 border border-slate-700 rounded-2xl p-4 mb-6 flex flex-wrap items-center justify-between gap-4 text-xs text-slate-300",
        div(span(class = "text-slate-400", "File Aktif: "), tags$strong(class = "text-white", info$filename), span(class = "text-slate-500 ml-1", paste0("(", info$file_size, ")"))),
        div(span(class = "text-slate-400", "Total Missing Cells: "), tags$strong(class = "text-amber-400", paste0(info$total_missing, " (", info$missing_pct, "%)"))),
        div(span(class = "text-slate-400", "Baris Duplikat: "), tags$strong(class = "text-rose-400", info$duplicate_rows))
    )
  })
  
  output$preview_table <- renderDT({
    req(reactive_data$df)
    datatable(head(reactive_data$df, 10), options = list(dom = "t", bSort = FALSE, paging = FALSE, scrollX = TRUE))
  })
  
  output$numeric_summary_ui <- renderUI({
    req(reactive_data$stats)
    if (length(reactive_data$num_cols) == 0) return(p(class = "text-slate-400 text-sm", "Tidak ditemukan kolom numerik."))
    div(class = "space-y-4 max-h-[450px] overflow-y-auto pr-2",
        lapply(reactive_data$num_cols, function(col) {
          curr_stat <- reactive_data$stats$numerical[[col]]
          div(class = "bg-slate-900/60 border border-slate-700/50 p-4 rounded-xl",
              div(class = "flex justify-between items-center mb-2",
                  h5(class = "font-semibold text-sky-400 text-sm", col),
                  span(class = "text-[11px] px-2 py-0.5 rounded bg-amber-500/10 text-amber-300", paste0("Outlier (IQR): ", curr_stat$outliers))
              ),
              div(class = "grid grid-cols-2 gap-2 text-xs text-slate-300",
                  p(class = "flex justify-between", "Mean:", tags$strong(curr_stat$mean)),
                  p(class = "flex justify-between", "Std. Dev:", tags$strong(curr_stat$sd)),
                  p(class = "flex justify-between", "Median:", tags$strong(curr_stat$median)),
                  p(class = "flex justify-between", "Q1 - Q3:", tags$strong(paste0(curr_stat$q1, " - ", curr_stat$q3))),
                  p(class = "flex justify-between", "Min:", tags$strong(curr_stat$min)),
                  p(class = "flex justify-between", "Max:", tags$strong(curr_stat$max))
              ),
              div(class = "mt-2 pt-2 border-t border-slate-800 text-[11px] text-rose-400 flex justify-between",
                  "Missing Values:", paste0(curr_stat$missing_values, " (", curr_stat$missing_percentage, "%)"))
          )
        })
    )
  })
  
  output$categorical_summary_ui <- renderUI({
    req(reactive_data$stats)
    if (length(reactive_data$cat_cols) == 0) return(p(class = "text-slate-400 text-sm", "Tidak ditemukan kolom kategorikal."))
    div(class = "space-y-4 max-h-[450px] overflow-y-auto pr-2",
        lapply(reactive_data$cat_cols, function(col) {
          curr_stat <- reactive_data$stats$categorical[[col]]
          div(class = "bg-slate-900/60 border border-slate-700/50 p-4 rounded-xl",
              h5(class = "font-semibold text-rose-400 mb-2 text-sm", col),
              div(class = "space-y-1 text-xs text-slate-300",
                  p(class = "flex justify-between", "Kategori Unik:", tags$strong(curr_stat$unique_categories)),
                  p(class = "flex justify-between", "Modus (Mode):", tags$strong(class = "truncate max-w-[180px]", curr_stat$mode)),
                  p(class = "flex justify-between", "Frekuensi Modus:", tags$strong(paste0(curr_stat$mode_frequency, " (", curr_stat$mode_percentage, "%)")))
              ),
              div(class = "mt-2 pt-2 border-t border-slate-800 text-[11px] text-rose-400 flex justify-between",
                  "Missing Values:", paste0(curr_stat$missing_values, " (", curr_stat$missing_percentage, "%)"))
          )
        })
    )
  })
  
  output$num_dist_plot <- renderPlot({
    req(reactive_data$df, input$sel_num_col)
    plot_numeric_distribution(reactive_data$df, input$sel_num_col, input$sel_num_type)
  })
  
  output$cat_bar_plot <- renderPlot({
    req(reactive_data$df, input$sel_cat_col)
    plot_categorical_bar(reactive_data$df, input$sel_cat_col)
  })
  
  output$cor_heatmap_plot <- renderPlot({
    req(reactive_data$df, reactive_data$num_cols)
    plot_correlation_heatmap(reactive_data$df, reactive_data$num_cols)
  })
  
  output$download_stats_btn <- downloadHandler(
    filename = function() {
      paste0("EDA_Summary_", tools::file_path_sans_ext(reactive_data$info$filename), ".csv")
    },
    content = function(file) {
      req(reactive_data$stats)
      rows <- list()
      for (col in names(reactive_data$stats$numerical)) {
        s <- reactive_data$stats$numerical[[col]]
        rows[[length(rows) + 1]] <- data.frame(
          Kolom = col, Tipe = "Numerik", Mean = s$mean, SD = s$sd, Median = s$median,
          Min = s$min, Max = s$max, Outlier_IQR = s$outliers,
          Kategori_Unik = NA, Modus = NA, Missing_Count = s$missing_values, Missing_Pct = s$missing_percentage
        )
      }
      for (col in names(reactive_data$stats$categorical)) {
        s <- reactive_data$stats$categorical[[col]]
        rows[[length(rows) + 1]] <- data.frame(
          Kolom = col, Tipe = "Kategorikal", Mean = NA, SD = NA, Median = NA,
          Min = NA, Max = NA, Outlier_IQR = NA,
          Kategori_Unik = s$unique_categories, Modus = s$mode, Missing_Count = s$missing_values, Missing_Pct = s$missing_percentage
        )
      }
      summary_export <- do.call(rbind, rows)
      write.csv(summary_export, file, row.names = FALSE)
    }
  )
}

shinyApp(ui = ui, server = server)
