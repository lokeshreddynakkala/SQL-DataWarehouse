
# 📘 SQL Data Warehouse Project
A complete end-to-end Data Warehouse built using SQL with multi-layered architecture (Bronze, Silver, Gold).


## 🧩 Overview
This project demonstrates the design and implementation of a **SQL-based Data Warehouse** for integrating data from multiple source systems — **CRM** and **ERP** — to enable unified business reporting and analytics.

The data pipeline is built using a **three-layer architecture**:
- **Bronze Layer:** Raw data ingestion
- **Silver Layer:** Data cleaning and transformation
- **Gold Layer:** Analytical models and reporting views

The goal is to ensure **data quality, consistency, and performance** for enterprise-level analytical workloads.

---

## 🏗️ Project Architecture
```
Source Systems (CRM / ERP)
        ↓
     Bronze Layer
 (Raw Data Storage)
        ↓
     Silver Layer
 (Data Cleaning & Transformation)
        ↓
      Gold Layer
 (Business Views & Reporting)
        ↓
     Reports & Analysis
```

---

## ⚙️ Tech Stack
- **Database:** SQL Server / Azure SQL
- **Language:** T-SQL (Structured Query Language)
- **Tools:** SSMS / Azure Data Studio
- **Data Sources:** CRM and ERP datasets (CSV files)
- **Reporting:** SQL reports and analytics queries

---

## 📂 Folder Structure
```
SQL-DataWarehouse-main/
│
├── datasets/
│   ├── source_crm/             → CRM raw data (cust_info, prd_info, sales_details)
│   └── source_erp/             → ERP raw data (cust_info, prd_info, sales_details)
│
├── scripts/
│   ├── bronze/SQL_quaries.sql  → Data ingestion scripts
│   ├── silver/                 → Data cleaning and transformation scripts
│   │   ├── data cleaning crm.sql
│   │   ├── data cleaning erp.sql
│   │   ├── data insertion.sql
│   │   └── Create_Tables
│   ├── gold/view.sql           → Final analytical layer (data marts/views)
│   └── Reports/Report.sql      → Reporting queries
│
├── tests/
│   ├── ADA/Quaries.sql         → Analytical Data Analysis
│   └── EDA/Quaries.sql         → Exploratory Data Analysis
│
└── README.md                   → Project documentation
```

---

## 🔄 Data Flow Explanation
1. **Bronze Layer:**  
   - Loads raw data from CSV files (CRM & ERP).  
   - Minimal or no transformation — stores raw snapshots.  
   - Script: `scripts/bronze/SQL_quaries.sql`

2. **Silver Layer:**  
   - Cleans and merges CRM and ERP datasets.  
   - Handles duplicates, null values, and inconsistencies.  
   - Scripts: `data cleaning crm.sql`, `data cleaning erp.sql`, `data insertion.sql`

3. **Gold Layer:**  
   - Creates analytical **views or data marts**.  
   - Joins facts and dimensions for business queries.  
   - Script: `scripts/gold/view.sql`

4. **Reports:**  
   - Generates analytical reports and KPIs.  
   - Script: `scripts/Reports/Report.sql`

---

## 🧠 Implementation Details
Each layer corresponds to a specific phase in the ETL process:

| Layer | Purpose | Example Script |
|--------|----------|----------------|
| Bronze | Ingest raw data from CRM/ERP | `bronze/SQL_quaries.sql` |
| Silver | Clean and prepare data | `silver/data cleaning crm.sql` |
| Gold | Build analytical views | `gold/view.sql` |
| Report | Query results and KPIs | `Reports/Report.sql` |

---

## 📊 Reports & Analysis
Sample business queries include:
- Total Sales by Region / Product / Customer  
- Top 10 Products by Revenue  
- Year-over-Year Sales Growth  
- Customer Retention Analysis

---

## 📈 Results
- Data successfully integrated from multiple sources (CRM, ERP).  
- Cleaned and transformed data across layers.  
- Created analytical reports for sales performance and customer insights.  
- Demonstrated the use of **modular ETL architecture** for scalability.

---

## 🔮 Future Enhancements
- Automate ETL using Python or SSIS.  
- Integrate visualization dashboards (Power BI / Tableau).  
- Deploy on cloud data platforms (Azure Synapse / Snowflake).  
- Add incremental data loading and scheduling.

---

## 👨‍💻 Author
**N_LOKESH_REDDY**  
📧 loke67b2@gmail.com
🔗 https://github.com/lokeshreddynakkala/SQL-DataWarehouse

