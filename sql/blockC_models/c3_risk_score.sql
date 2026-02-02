CREATE OR REPLACE VIEW c3_risk_score AS
WITH weights AS (
    SELECT
        'baseline' AS scenario,
        0.25 AS w_dependency,
        0.20 AS w_ageing_speed,
        0.20 AS w_ageing_momentum,
        0.15 AS w_child,
        0.10 AS w_volatility,
        0.10 AS w_avg_yoy

    UNION ALL
    SELECT
        'ageing_heavy',
        0.30, 0.25, 0.20, 0.10, 0.10, 0.05

    UNION ALL
    SELECT
        'fertility_heavy',
        0.20, 0.15, 0.15, 0.30, 0.10, 0.10
),
scored AS (
    SELECT
        n.country_code,
        w.scenario,
        ROUND(
              n.n_dependency        * w.w_dependency
            + n.n_ageing_speed      * w.w_ageing_speed
            + n.n_ageing_momentum   * w.w_ageing_momentum
            + (1 - n.n_child_share) * w.w_child
            + n.n_volatility        * w.w_volatility
            + (1 - n.n_avg_yoy)     * w.w_avg_yoy
        , 3) AS risk_score
    FROM c2_normalized_metrics n
    CROSS JOIN weights w
)
SELECT
    country_code,
    scenario,
    risk_score,
    CASE
        WHEN risk_score IS NULL THEN 'INSUFFICIENT DATA'
        WHEN risk_score >= 0.7 THEN 'High'
        WHEN risk_score >= 0.5 AND risk_score < 0.7 THEN 'Medium'
        ELSE 'Low'
    END AS risk_tier
FROM scored
WHERE risk_score IS NOT NULL
ORDER BY
    scenario,
    CASE WHEN risk_score IS NULL THEN 1 ELSE 0 END,
    risk_score DESC;