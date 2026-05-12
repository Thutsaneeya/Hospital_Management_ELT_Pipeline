-- DATA QUALITY CHECK

-- 1. Check for Duplicate Appointments
SELECT appointment_id,
  COUNT(*) AS duplicate_count
FROM `hospital-management-pipeline.hospital_management_transformed.patient_appointments`
GROUP BY 1
HAVING COUNT(*) > 1;

-- 2. Logic Check: Appointment Categories
-- Verify that 'Completed', 'No-show', and 'Cancelled' are correctly mapped to 'Past'.
SELECT appointment_status, appointment_category, COUNT(*) AS record_count
FROM `hospital-management-pipeline.hospital_management_transformed.patient_appointments`
GROUP BY 1, 2
ORDER BY 2;

-- 3. Logic Check: Treatment & Revenue Categories
-- Verify that ECG/MRI/X-Ray are 'Diagnostics' and payment statuses are correctly grouped.
SELECT
  treatment_type,
  treatment_category,
  payment_status,
  revenue_category,
  COUNT(*) AS record_count
FROM `hospital-management-pipeline.hospital_management_transformed.patient_billing_summary`
GROUP BY 1, 2, 3, 4;

-- 4. Check for Impossiblt Ages
SELECT patient_id, patient_full_name, patient_age
FROM `hospital-management-pipeline.hospital_management_transformed.patient_appointments`
  WHERE patient_age < 0 OR patient_age > 120;

-- 5. Billing Variance Check
SELECT *
FROM `hospital-management-pipeline.hospital_management_transformed.patient_billing_summary`
WHERE billing_variance != 0;

-- 6. Null Patient Name Check
SELECT appointment_id, patient_full_name
FROM `hospital-management-pipeline.hospital_management_transformed.patient_appointments`
WHERE appointment_id IS NOT NULL AND patient_full_name IS NULL;

