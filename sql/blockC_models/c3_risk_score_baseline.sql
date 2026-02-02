CREATE OR REPLACE VIEW c3_risk_score_baseline AS
SELECT
    country_code,
    risk_score,
    risk_tier
FROM c3_risk_score
WHERE scenario = 'baseline';