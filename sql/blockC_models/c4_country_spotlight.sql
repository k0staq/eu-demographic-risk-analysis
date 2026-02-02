CREATE OR REPLACE VIEW c4_country_spotlight AS
SELECT
    c1.country_code,

    /* core metrics */
    c1.dependency_ratio_2024,
    c1.child_share_2024,
    c1.ageing_speed,
    c1.ageing_momentum,
    c1.avg_yoy_pct,
    c1.yoy_volatility,

    /* normalized */
    c2.n_dependency,
    c2.n_child_share,
    c2.n_ageing_speed,
    c2.n_ageing_momentum,
    c2.n_avg_yoy,
    c2.n_volatility,

    /* baseline risk */
    r.risk_score,
    r.risk_tier,

    /* peer groups */
    CASE
        WHEN c1.country_code IN ('CZ','SK') THEN 'CZ–SK core'
        WHEN c1.country_code IN ('CZ','SK','PL','HU') THEN 'V4'
        WHEN c1.country_code IN ('BG','RO','HR','SI','RS','LT','LV','EE')
            THEN 'Post-Communist'
        WHEN c1.country_code IN ('IT','PT','ES')
            THEN 'Southern high-ageing'
        WHEN c1.country_code IN ('IE','LU','IS')
            THEN 'Low-ageing reference'
        ELSE 'Other EU'
    END AS peer_group,

    CASE WHEN c1.country_code = 'CZ' THEN 1 ELSE 0 END AS is_cz,
    CASE WHEN c1.country_code = 'SK' THEN 1 ELSE 0 END AS is_sk

FROM c1_country_snapshot c1
LEFT JOIN c2_normalized_metrics c2
    ON c1.country_code = c2.country_code
LEFT JOIN c3_risk_score_baseline r
    ON c1.country_code = r.country_code;