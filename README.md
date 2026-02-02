# 📊 EU Demographic Risk & Population Outlook Analysis

📄 **Final analytical report (PDF):**  
[EU_Demographic_Risk_Analysis.pdf](./report/EU_Demographic_Risk_Analysis.pdf)

---

## Executive Summary

This project analyzes long-term demographic dynamics across European countries using Eurostat population data.  
The objective is to identify **structural demographic risks**—population decline, population ageing, and workforce pressure—rather than short-term demographic fluctuations.

The analysis combines historical population trends, age-structure indicators, and acceleration metrics to distinguish between temporary shocks and persistent demographic trajectories. Particular attention is paid to countries where current demographic pressure appears manageable, but long-term dynamics indicate rising fiscal and economic stress.

Later stages extend the analysis into **population forecasting and scenario-based risk interpretation**, with a focus on Czechia and Slovakia in the broader EU context.

---

## Table of Contents
- [Project Overview](#project-overview)
- [Data & Methodology](#data--methodology)
- [Key Findings](#key-findings)
- [Block C – Risk Segmentation](#block-c--risk-segmentation)
- [Block D – Forecasting & Forward-Looking Risk](#block-d--forecasting--forward-looking-risk)
- [Tools & Stack](#tools--stack)
- [Project Structure](#project-structure)
- [Next Steps](#next-steps)

---

## Project Overview

This project examines demographic development across Europe with a focus on:

- long-term population change  
- demographic ageing and dependency pressure  
- workforce sustainability  
- cross-country and regional differences  

Demography is treated as a **structural economic risk factor**, not merely as a descriptive statistical outcome.

---

## Data & Methodology

### Data
- **Eurostat – DEMO_PJAN**  
  Population on 1 January by age and sex  
- Time range: **1960–2025**
- Raw Eurostat datasets are not committed to the repository due to size constraints. Data can be downloaded directly from Eurostat DEMO_PJAN.

### Methodology
- Data ingestion and preprocessing in **PostgreSQL**
- Aggregation of age-level data into demographic groups
- Year-over-year population change analysis (absolute & relative)
- Volatility measurement using standard deviation
- Identification of structural breaks and trend stability
- Age-structure analysis:
  - dependency ratios  
  - workforce share  
  - ageing speed and demographic momentum  

---

## Key Findings

### Block A – Population Trends
- Relative YoY (%) analysis reveals **structural population decline** in Eastern Europe and parts of the Balkans
- Regional differences persist even after normalization
- Structural breaks observed around **1990, 2008, and 2021**
- Stability metrics identify countries suitable for reliable long-term forecasting

📄 **Detailed insights:**  
[`/insights/blockA_summary.md`](./insights/blockA_summary.md)

### Block B – Age Structure & Workforce Dynamics
- Highest dependency pressure observed in IT, PT, BG, FI  
- Czechia currently sits close to the EU average, but ageing dynamics are accelerating
- Fastest-ageing countries face rising pressure on pension systems, healthcare, and labor markets
- Countries with declining workforce shares exhibit elevated long-term fiscal risk

📄 **Detailed insights:**  
[`/insights/blockB_summary.md`](./insights/blockB_summary.md)

---

## Block C – Risk Segmentation

> **Key insight:**  
> Countries combining low child population share with accelerating ageing momentum face the highest long-term demographic risk—even when current dependency ratios remain moderate.

Block C integrates normalized demographic indicators into a **composite demographic risk score** and tests its robustness under alternative weighting scenarios. Results show that elevated demographic risk is **structural and persistent**, rather than driven by short-term volatility or modelling assumptions.

Czechia and Slovakia consistently rank above the EU average and align closely with post-communist regional peer groups, indicating a predominantly regional demographic pattern rather than an EU-wide anomaly.

📄 **Detailed insights:**  
[`/insights/blockC_summary.md`](./insights/blockC_summary.md)

---

## Block D – Forecasting & Forward-Looking Risk

Block D extends the analysis into a forward-looking perspective by linking **current demographic risk** with **future population outcomes**.

Key components include:
- Indexed population trajectories (2000 = 100) with illustrative forecasts to 2050
- Comparison of Czechia, Slovakia, and the EU average
- Integration of current risk scores with projected population change

This block demonstrates that countries with higher present-day demographic risk are significantly more likely to experience population decline over the medium to long term, reinforcing the structural nature of demographic risk.

📄 **Detailed insights:**  
[`/insights/blockD_summary.md`](./insights/blockD_summary.md)

---

## Tools & Stack

- **PostgreSQL / SQL** – data ingestion, transformation, and analytical modelling  
- **Power BI** – analytical visualization and reporting  
- **Python** – exploratory forecasting and scenario analysis  

---

## Project Structure

/
├── data/
│ └── raw/ # Source demographic datasets (Eurostat)
│
├── sql/
│ ├── blockA_raw/ # Raw ingestion and base transformations
│ ├── blockB_metrics/ # Derived demographic indicators
│ ├── blockC_models/ # Risk models and analytical logic
│ └── blockD_views/ # BI-facing presentation views
│
├── python/
│ ├── 01_population_trends_and_forecast.ipynb
│ ├── 02_dependency_and_workforce_outlook.ipynb
│ └── 03_risk_vs_future_decline.ipynb
│
├── powerbi/
│ └── eu_demographic_vis.pbix
│
├── insights/
│ ├── blockA_summary.md
│ ├── blockB_summary.md
│ ├── blockC_summary.md
│ └── blockD_summary.md
│
├── report/
│ └── EU_Demographic_Risk_Analysis.pdf
│
└── README.md

## Next Steps

- Extend forecasts using cohort-component or official projection methodologies
- Incorporate migration and fertility scenarios
- Link demographic risk outcomes to fiscal and labor market implications
- Refine forecasting assumptions and sensitivity analysis

---

*This project is designed as an end-to-end analytical case study, combining SQL-based modelling, exploratory Python analysis, and executive-ready Power BI reporting.*