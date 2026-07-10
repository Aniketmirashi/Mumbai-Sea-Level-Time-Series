# Mumbai Sea Level Time Series Analysis (1878–1961)

![R](https://img.shields.io/badge/R-276DC3?style=for-the-badge&logo=r&logoColor=white)
![Time Series](https://img.shields.io/badge/Time-Series-blue?style=for-the-badge)
![ARIMA](https://img.shields.io/badge/ARIMA-Forecasting-success?style=for-the-badge)
![Climate Change](https://img.shields.io/badge/Climate-Research-green?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-orange?style=for-the-badge)

---

## Overview

Sea level rise is one of the most significant indicators of long-term climate change. Understanding historical sea-level variability provides valuable insight into coastal dynamics, climate variability, and future environmental risks.

This project performs a comprehensive **time-series analysis** of monthly sea-level observations recorded at **Mumbai (Apollo Bandar), India**, between **1878 and 1961** using statistical and forecasting techniques in **R**.

The workflow includes data preprocessing, visualization, decomposition, trend analysis, forecasting, and residual diagnostics to understand historical sea-level behavior and evaluate predictive performance.

---

## Dataset

**Source**

Permanent Service for Mean Sea Level (PSMSL)

https://psmsl.org/data/obtaining/stations/43.php

**Station**

Mumbai (Apollo Bandar), India

- Time Period: **1878–1961**
- Monthly observations: **1008**
- Gap-free historical record
- Quality-controlled observations

---

# Workflow

```
Raw Data
      │
      ▼
Data Cleaning
      │
      ▼
Time Series Construction
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

✔ Data Cleaning

✔ Monthly Time Series

✔ Annual Mean Analysis

✔ Linear Regression

✔ STL Decomposition

✔ Mann–Kendall Trend Test

✔ Seasonal Mann–Kendall Test

✔ Theil–Sen Estimator

✔ ARIMA Forecasting

✔ Forecast Accuracy Assessment

✔ Residual Diagnostics

---

# Results

## Monthly Sea Level

Shows the long-term increase in monthly sea-level observations.

![Monthly Series](images/monthly_series.png)

---

## Annual Mean Trend

Annual averages reduce seasonal variability and highlight the long-term increasing trend.

![Annual Trend](images/annual_trend.png)

---

## Sea Level Anomaly Stripes

Climate-stripe visualization illustrating below-average and above-average sea-level conditions throughout the study period.

![Anomaly](images/anomaly_stripes.png)

---

## Calendar Heatmap

Monthly variability across the complete historical record.

![Heatmap](images/heatmap.png)

---

## STL Decomposition

Seasonal-Trend decomposition separates the observed signal into:

- Trend
- Seasonal
- Residual

![STL](images/stl.png)

---

## ARIMA Forecast

Forecasting of the final two years using Seasonal ARIMA.

![Forecast](images/forecast.png)

---

## Residual Diagnostics

Model adequacy evaluated using residual analysis and Q-Q plot.

![Diagnostics](images/qqplot.png)

---

# Key Findings

| Analysis | Result |
|-----------|--------|
| Linear Trend | **0.914 mm/year** |
| Mann–Kendall | Significant Increasing Trend |
| Seasonal Mann–Kendall | Significant |
| Theil–Sen Slope | **0.862 mm/year** |
| ARIMA | Good Short-term Forecast |
| Theil's U | **0.81** (Better than Naive Forecast) |

---

# Repository Structure

```
Mumbai-Sea-Level-Time-Series
│
├── data
│   └── 43.rlrdata.txt
│
├── scripts
│   └── Sea_Level_Rise_Timeseries.R
│
├── images
│
├── report
│   └── Timeseries_Assignment.pdf
│
├── README.md
└── LICENSE
```

---

# Software

- R
- tidyverse
- forecast
- trend
- zoo
- viridis
- ggplot2
- ggridges

---

# Future Improvements

- Prophet Forecasting
- LSTM Deep Learning Models
- Wavelet Analysis
- Climate Index Correlation (ENSO, IOD)
- Comparison with Satellite Altimetry
- Interactive Dashboard (Shiny)

---

# Author

### **Jyotiprakash G. Mirashi**

M.Sc. Climate Change and Sustainability

Azim Premji University

**Interests**

- Climate Analytics
- GIS & Remote Sensing
- Environmental Data Science
- Time Series Analysis
- Carbon Dynamics
- Biodiversity Informatics

---

# Citation

If you use this work, please cite the repository.

```text
Mirashi, J.G. (2026)

Mumbai Sea Level Time Series Analysis (1878–1961)

GitHub Repository
```

---

# License

This project is licensed under the MIT License.

---

## If you found this repository useful, consider giving it a Star!
