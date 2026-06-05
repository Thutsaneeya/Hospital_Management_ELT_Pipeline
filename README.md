# Hospital Management ELT Pipeline using GCP
A complete End-to-End ELT Pipeline using Google Cloud Platform and Data Studio for Hospital Financial Analysis.

## Datasets
Source: [Hospital Management Dataset](https://www.kaggle.com/datasets/kanakbaghel/hospital-management-dataset)
| Table | Description | Rows | 
|-------|-------------|------:|
| **patients** | Stores patient demographic, contact, and insurance information | 50 |
| **doctors** | Stores doctor profiles including specialization and experience | 10 |
| **appointments** | Stores appointment schedules, reasons for visits, and statuses | 200 |
| **treatments** | Stores treatment details and associated costs | 200 |
| **billing** | Stores billing records and payment status linked to treatments | 200 |

## Tech Stack
- Google Cloud Platform
- Google Cloud Shell
- BigQuery
- Data Studio
- SQL

## Architecture
![Architecture Diagram](assets/architecture_diagram.png)
- **Data Ingestion:** Loaded raw CSV files into BigQuery Sandbox using Cloud Shell commands.
- **ELT Pipeline:** Developed an ELT pipeline using SQL transformations to process data within the data warehouse.
- **SQL View:** Built a SQL view to prepare clean dataset for analytics.
- **Visualization:** Delivered insights through an interactive dashboard in Data Studio

## Data Studio Dashboard
[Hospital Financial Summary Report](data_studio_dashboard/Hospital_Financial_Summary_Report.pdf)
![Report Dashboard](assets/report_dashboard.png)

## Project Structure
📁 `Hospital_Management_ELT_Pipeline/`
- 📁 `assets/` → Image
- 📁 `data/` →  Raw Dataset
- 📁 `data_studio_dashboard/` →  Final Dashboard Report (PDF)
- 📁 `sql_script/` →  BigQuery SQL scripts
- README.md
