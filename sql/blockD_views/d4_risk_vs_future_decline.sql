CREATE VIEW d4_risk_vs_future_decline AS
SELECT
    country_code,
    risk_score,
    forecast_pop_change_2025_2050,
    risk_tier
FROM c6_risk_vs_future_decline;