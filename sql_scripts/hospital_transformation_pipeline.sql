-- Create the destination dataset if it doesn't exist
CREATE SCHEMA IF NOT EXISTS `hospital-management-pipeline.hospital_management_transformed`;

-- 1. Combine and Transform data
-- This query joins patient and appointment data, cleans names, and calculates patient age.
CREATE OR REPLACE TABLE `hospital-management-pipeline.hospital_management_transformed.patient_appointments`
AS
SELECT
  t1.patient_id,
  CONCAT(UPPER(t1.first_name), ' ', UPPER(t1.last_name)) AS patient_full_name,
  t1.gender,
  t1.date_of_birth,
-- Calculate age as of today
  DATE_DIFF(CURRENT_DATE(), t1.date_of_birth, YEAR) AS patient_age,
 t1.insurance_provider,
  -- Handling NULL IDs: Replace NULL with 'NO_APPOINTMENT'
  IFNULL(t2.appointment_id, 'NO_APPOINTMENT') AS appointment_id,
  -- Handling NULL date: Replace NULL with 'None'
  IFNULL(t2.appointment_date, DATE '1900-01-01') AS appointment_date,
  -- Handling NULL Status: Replace NULL with 'None'
  IFNULL(t2.status, 'None') AS appointment_status,
  -- Label appointments based on status and original date
  CASE
    WHEN t2.status IS NULL THEN 'No Appointments'
    WHEN t2.status IN ('Completed', 'No-show', 'Cancelled') THEN 'Past'
    WHEN t2.status = 'Scheduled' THEN 'Upcoming'
    ELSE 'Uncategorized'
    END
    AS appointment_category
FROM `hospital-management-pipeline.hospital_management_raw.patients` AS t1
LEFT JOIN
  `hospital-management-pipeline.hospital_management_raw.appointments` AS t2
  ON t1.patient_id = t2.patient_id;

-- 2. Doctor Performance Table
-- This query joins doctor data with appointment counts to analyze workload.
CREATE OR REPLACE TABLE `hospital-management-pipeline.hospital_management_transformed.doctor_performance` AS
SELECT
  d.doctor_id,
  CONCAT(d.first_name, ' ', d.last_name) AS doctor_full_name,
  d.specialization,
  d.years_experience,
  COUNT(a.appointment_id) AS total_appointments,
  COUNT(DISTINCT a.patient_id) AS unique_patients_seen
FROM `hospital-management-pipeline.hospital_management_raw.doctors` AS d
LEFT JOIN `hospital-management-pipeline.hospital_management_raw.appointments` AS a
  ON d.doctor_id = a.doctor_id
GROUP BY 1, 2, 3, 4;

-- 3. Patient Billing Summary Table
-- This query combines billing and treatment data to analyze revenue by treatment type and patient.
CREATE OR REPLACE TABLE `hospital-management-pipeline.hospital_management_transformed.patient_billing_summary`
AS
SELECT
  b.bill_id,
  b.patient_id,
  b.bill_date,
  b.amount AS billed_amount,
  b.payment_status,
  CASE
    WHEN b.payment_status = 'Paid' THEN 'Realized Revenue'
    WHEN b.payment_status = 'Pending' THEN 'Outstanding'
    WHEN b.payment_status = 'Failed' THEN 'Collections/Risk'
    ELSE 'Other'
    END
    AS revenue_category,
  UPPER(TRIM(t.treatment_type)) AS treatment_type,
  -- Detailed Logic for Hospital Services:
  CASE
    WHEN t.treatment_type IN ('MRI', 'X-Ray', 'ECG') THEN 'Diagnostics/Imaging'
    WHEN t.treatment_type = 'Chemotherapy' THEN 'Oncology'
    WHEN t.treatment_type = 'Physiotherapy' THEN 'Rehabilitation'
    ELSE 'General/Specialized Care'
    END
    AS treatment_category,
  t.cost AS treatment_cost,
  ROUND(b.amount - t.cost, 2) AS billing_variance
FROM `hospital-management-pipeline.hospital_management_raw.billing` AS b
JOIN `hospital-management-pipeline.hospital_management_raw.treatments` AS t
  ON b.treatment_id = t.treatment_id;