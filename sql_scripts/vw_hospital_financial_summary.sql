-- Create view for dashboard

CREATE OR REPLACE VIEW `hospital-management-pipeline.hospital_management_transformed.vw_looker_financial_summary`
AS
SELECT
  bill_date,
  -- FORMAT_DATE('%B', bill_date) AS month_name,
  -- FORMAT_DATE('%Y-%m', bill_date) AS month_sort,
  revenue_category,
  payment_status,
  treatment_type,
  billed_amount,
  treatment_cost,
  billing_variance,
  SUM(billed_amount)
    OVER (PARTITION BY FORMAT_DATE('%Y-%m', bill_date))
    AS monthly_revenue_running_total,
   CASE
    WHEN payment_status = 'Paid' THEN billed_amount
    ELSE 0
    END
    AS collected_revenue,
   CASE
    WHEN payment_status IN ('Pending', 'Failed') THEN billed_amount
    ELSE 0
    END
    AS pending_revenue
FROM `hospital-management-pipeline.hospital_management_transformed.patient_billing_summary`;


-- SELECT *,
  -- Calculate Total Cash per month to find Growth %
  -- SUM(collected_revenue) OVER (PARTITION BY month_sort) AS total_monthly_cash,
  -- Get Previous Month's Cash
  -- LAG(SUM(collected_revenue)) OVER (ORDER BY month_sort) AS prev_month_cash,
  -- Growth Calculation: ((Current - Previous) / Previous) * 100
  -- SAFE_DIVIDE(
    -- SUM(collected_revenue)
      -- OVER (PARTITION BY month_sort)
      -- - LAG(SUM(collected_revenue)) OVER (ORDER BY month_sort),
    -- LAG(SUM(collected_revenue)) OVER (ORDER BY month_sort))
    -- * 100 AS cash_growth_percentage
-- FROM monthly_cash
-- GROUP BY 1, 2, 3, 4, 5, 6, 7, 8;


