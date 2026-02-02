CREATE VIEW d1_risk_overview AS
SELECT
    country_code,
    risk_score,
    risk_tier
FROM c3_risk_score;