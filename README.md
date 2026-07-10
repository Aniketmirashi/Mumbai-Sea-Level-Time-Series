# Mumbai Sea Level Time Series Analysis (1878–1961)

<p align="center">
  <img src="https://img.shields.io/badge/R-276DC3?style=for-the-badge&logo=r&logoColor=white">
  <img src="https://img.shields.io/badge/Time%20Series-Analysis-blue?style=for-the-badge">
  <img src="https://img.shields.io/badge/ARIMA-Forecasting-success?style=for-the-badge">
  <img src="https://img.shields.io/badge/Climate-Research-green?style=for-the-badge">
  <img src="https://img.shields.io/badge/License-MIT-orange?style=for-the-badge">
</p>

---

## Overview

Sea level rise is one of the most important indicators of long-term climate change. Understanding historical sea-level variability provides valuable insights into coastal dynamics, climate variability, and future environmental risks.

This project presents a comprehensive **time-series analysis** of monthly sea-level observations recorded at **Mumbai (Apollo Bandar), India**, from **1878 to 1961** using statistical and forecasting techniques in **R**.

The workflow includes data preprocessing, visualization, decomposition, statistical trend analysis, forecasting, and residual diagnostics to understand historical sea-level behaviour and evaluate model performance.

---

## 📊 Dataset

**Source**

**Permanent Service for Mean Sea Level (PSMSL)**

https://psmsl.org/data/obtaining/stations/43.php

**Station**

Mumbai (Apollo Bandar), India

| Attribute | Details |
|------------|---------|
| Time Period | **1878–1961** |
| Observations | **1008 Monthly Records** |
| Dataset Type | Gap-free Continuous Record |
| Quality | Quality-controlled observations |

---

# Workflow

```text
Raw Sea Level Data
        │
        ▼
Data Cleaning & Quality Control
        │
        ▼
Monthly Time Series Construction
        │
        ▼
Visualization
        │
        ▼
Trend Analysis
        │
        ▼
STL Decomposition
        │
        ▼
ARIMA Forecasting
        │
        ▼
Residual Diagnostics
```

---

# Statistical Methods

- Data Cleaning
- Monthly Time-Series Construction
- Annual Mean Analysis
- Linear Regression
- STL Decomposition
- Mann–Kendall Trend Test
- Seasonal Mann–Kendall Test
- Theil–Sen Slope Estimation
- Seasonal ARIMA Forecasting
- Forecast Accuracy Assessment
- Residual Diagnostics

---

# Results

## Monthly Sea Level Time Series

Monthly sea-level observations reveal pronounced seasonal variability together with a persistent long-term increase throughout the 84-year study period. A fitted linear regression line highlights the statistically significant upward trend.

<p align="center">
<img src="figures/monthly_series.png" width="900">
</p>

---

## Annual Mean Sea Level

Annual averaging reduces seasonal fluctuations and provides a clearer representation of long-term sea-level change.

Both **Linear Regression** and **LOESS smoothing** indicate a continuous increase in annual mean sea level between **1878 and 1961**.

<p align="center">
<img src="figures/annual_trend.png" width="900">
</p>

---

## Sea Level Anomaly Stripes

Sea-level anomalies were calculated relative to the long-term average (**6987 mm**). The anomaly stripe visualization clearly illustrates the transition from predominantly below-average sea levels in the early decades to increasingly above-average conditions during the latter half of the record.

<p align="center">
<img src="figures/anomaly_stripes.png" width="900">
</p>

---

## Calendar Heatmap

The calendar heatmap highlights seasonal variability and long-term temporal changes in monthly sea-level observations. Seasonal cycles remain consistent, while a gradual increase in sea level becomes evident through successive decades.

<p align="center">
<img src="figures/heatmap.png" width="900">
</p>

---

## STL Decomposition

Seasonal-Trend decomposition (STL) separates the observed series into:

- Trend
- Seasonal Component
- Residual Component

The decomposition demonstrates that long-term sea-level rise dominates the historical record while seasonal oscillations remain relatively stable.

<p align="center">
<img src="figures/stl.png" width="900">
</p>

---

## Seasonally Adjusted Series

Removing the seasonal component reveals the underlying long-term trend more clearly. The adjusted series confirms a gradual and persistent increase in sea level without major discontinuities.

<p align="center">
<img src="figures/seasonally_adjusted.png" width="900">
</p>

---

## Trend Analysis

Multiple statistical approaches consistently confirmed a significant increasing trend in sea level.

| Method | Result |
|---------|-------:|
| Linear Regression | **0.914 mm/year** |
| R² | **0.503** |
| Mann–Kendall Test | **z = 6.68 (p < 0.001)** |
| Kendall's Tau | **0.497** |
| Theil–Sen Slope | **0.862 mm/year** |
| Seasonal Mann–Kendall | **z = 13.41 (p < 0.001)** |

---

## ARIMA Forecasting

A Seasonal **ARIMA(0,1,3)(2,0,0)[12]** model was developed using observations from **1878–1959** and validated using data from **1960–1961**.

The model successfully reproduced seasonal dynamics and demonstrated good short-term forecasting performance.

<p align="center">
<img src="figures/forecast.png" width="900">
</p>

### Forecast Performance

| Metric | Value |
|---------|------:|
| RMSE | **61.77 mm** |
| MAE | **49.66 mm** |
| MAPE | **0.71 %** |
| Theil's U | **0.81** |

Since **Theil's U < 1**, the ARIMA model outperformed a naïve forecasting approach, indicating reliable short-term predictive capability.

---

## Residual Diagnostics

Residual analysis was performed using:

- Autocorrelation Function (ACF)
- Partial Autocorrelation Function (PACF)
- Ljung–Box Test
- Shapiro–Wilk Test
- Normal Q–Q Plot

The diagnostics indicate that the STL decomposition and ARIMA model capture the dominant temporal characteristics of the historical sea-level series, although minor residual autocorrelation remains.

<p align="center">
<img src="figures/qqplot.png" width="750">
</p>

---

# Key Findings

| Analysis | Result |
|-----------|--------|
| Study Period | **1878–1961 (84 Years)** |
| Monthly Observations | **1008** |
| Linear Trend | **0.914 mm/year** |
| Mann–Kendall Test | **Significant Increasing Trend** |
| Seasonal Mann–Kendall | **Highly Significant** |
| Theil–Sen Slope | **0.862 mm/year** |
| ARIMA Model | **ARIMA(0,1,3)(2,0,0)[12]** |
| Forecast Accuracy | **MAPE = 0.71%** |
| Theil's U | **0.81 (Better than Naïve Forecast)** |

---

# Repository Structure

```text
Mumbai-Sea-Level-Time-Series/
│
├── data/
│   └── 43.rlrdata.txt
│
├── scripts/
│   └── Sea_Level_Rise_Timeseries.R
│
├── figures/
│   ├── monthly_series.png
│   ├── annual_trend.png
│   ├── anomaly_stripes.png
│   ├── heatmap.png
│   ├── stl.png
│   ├── seasonally_adjusted.png
│   ├── forecast.png
│   └── qqplot.png
│
├── report/
│   └── Timeseries_Assignment_Jyotiprakash_MSCC1250022.pdf
│
├── README.md
└── LICENSE
```

---

# Software & Packages

- R
- tidyverse
- ggplot2
- forecast
- trend
- zoo
- viridis
- RColorBrewer
- ggridges

---

# Future Improvements

- Prophet Forecasting
- Deep Learning (LSTM)
- Wavelet Analysis
- ENSO & Indian Ocean Dipole Correlation
- Satellite Altimetry Comparison
- Interactive Shiny Dashboard

---

# Author

## **Jyotiprakash G. Mirashi**

**M.Sc. Climate Change and Sustainability**

Azim Premji University, Bengaluru

### Research Interests

- Climate Analytics
- Environmental Data Science
- GIS & Remote Sensing
- Time-Series Analysis
- Carbon Dynamics
- Biodiversity Informatics

---

# Citation

```text
Mirashi, J. G. (2026)

Mumbai Sea Level Time Series Analysis (1878–1961)

GitHub Repository
```

---

# License

This project is licensed under the **MIT License**.

---

## Support

If you found this project useful, consider giving the repository a **Star ⭐**.
It helps others discover the project and supports my work in climate data science and environmental analytics.
