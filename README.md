# Auto EDA Insight Platform

Aplikasi web interaktif berbasis **R Shiny** untuk melakukan **Exploratory Data Analysis (EDA)** secara otomatis, cepat, dan terstruktur. Dikembangkan sebagai proyek **UAS Data Science Programming (SD-1306)** — Program Studi Sains Data, Institut Teknologi dan Sains Bandung (ITSB).

---

## Fitur Utama

1. **Multi-Format Data Loader & Auto-Detection**
   - Mendukung format `.csv` (pemisah koma `,` maupun titik koma `;`), `.xlsx`, `.xls`, dan `.txt`.
   - Deteksi otomatis tipe kolom: Numerik, Kategorikal, dan Date/Time, serta pemeriksaan sel kosong (*missing values*) dan baris duplikat.
   - Dilengkapi tombol **Gunakan Sample Dataset** untuk pengujian instan.

2. **Statistik Deskriptif Komprehensif**
   - **Numerik:** Mean, Standar Deviasi (SD), Median, Kuartil (Q1 & Q3), Minimum, Maksimum, deteksi jumlah *outlier* berbasis metode IQR ($1.5 \times \text{IQR}$), serta persentase *missing values*.
   - **Kategorikal:** Jumlah kategori unik, Modus (*mode*), frekuensi dan persentase modus, serta *missing values*.

3. **Eksplorasi Visual & Korelasi Interaktif**
   - **Histogram & Boxplot** untuk melihat bentuk distribusi dan sebaran *outlier* variabel numerik.
   - **Bar Chart** untuk distribusi frekuensi kategori teratas.
   - **Heatmap Korelasi Pearson** antar-variabel numerik.

4. **Ekspor Laporan Ringkasan**
   - Unduh hasil ringkasan statistik seluruh variabel dalam format `.csv` dengan satu klik.

---

## Struktur Direktori

```text
Auto_EDA_Insight/
├── app.R                           # Aplikasi utama R Shiny (UI & Server)
├── Auto_EDA_Insight.Rproj          # File proyek RStudio
├── install_packages.R              # Skrip instalasi otomatis seluruh library R
├── README.md                       # Dokumentasi proyek
├── .gitignore                      # Konfigurasi file yang diabaikan Git
├── backend/
│   ├── data_loader.R               # Modul pembacaan file & deteksi tipe data
│   ├── descriptive_stats.R         # Modul kalkulasi statistik deskriptif & outlier
│   └── visualization.R             # Modul visualisasi ggplot2 (tema gelap)
├── data/
│   └── raw/
│       └── sample_sales_analytics.csv  # Dataset contoh bawaan
└── www/
    └── custom.css                  # Kustomisasi gaya antarmuka dashboard
```

---

## Cara Instalasi & Menjalankan Aplikasi

1. **Buka Proyek di RStudio**
   - Ekstrak folder `Auto_EDA_Insight` dan klik dua kali pada file `Auto_EDA_Insight.Rproj`.

2. **Instal Dependensi Paket R**
   - Jalankan perintah berikut di R Console:
     ```r
     source("install_packages.R")
     ```

3. **Jalankan Aplikasi Shiny**
   - Jalankan perintah berikut di R Console atau klik tombol **Run App** di `app.R`:
     ```r
     shiny::runApp()
     ```

---

## Informasi Akademik

- **Mata Kuliah:** Data Science Programming (SD-1306)
- **Program Studi:** S1 Sains Data — Institut Teknologi dan Sains Bandung (ITSB)
- **Dosen Pengampu:** Bakti Siregar, M.Sc.
