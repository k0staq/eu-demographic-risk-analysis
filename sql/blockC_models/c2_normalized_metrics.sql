CREATE OR REPLACE VIEW c2_normalized_metrics AS
WITH bounds AS (
    SELECT
        MIN(dependency_ratio_2024) AS min_dep,
        MAX(dependency_ratio_2024) AS max_dep,

        MIN(ageing_speed)          AS min_age_speed,
        MAX(ageing_speed)          AS max_age_speed,

        MIN(ageing_momentum)       AS min_momentum,
        MAX(ageing_momentum)       AS max_momentum,

        MIN(child_share_2024)      AS min_child,
        MAX(child_share_2024)      AS max_child,

        MIN(yoy_volatility)        AS min_vol,
        MAX(yoy_volatility)        AS max_vol,

        MIN(avg_yoy_pct)           AS min_yoy,
        MAX(avg_yoy_pct)           AS max_yoy
    FROM c1_country_snapshot
)

SELECT
    s.country_code,

    -- risk factors (higher = worse)
    (s.dependency_ratio_2024 - b.min_dep)
        / NULLIF(b.max_dep - b.min_dep, 0)        AS n_dependency,

    (s.ageing_speed - b.min_age_speed)
        / NULLIF(b.max_age_speed - b.min_age_speed, 0) AS n_ageing_speed,

    (s.ageing_momentum - b.min_momentum)
        / NULLIF(b.max_momentum - b.min_momentum, 0)   AS n_ageing_momentum,

    (s.yoy_volatility - b.min_vol)
        / NULLIF(b.max_vol - b.min_vol, 0)        AS n_volatility,

    -- protective factors (higher = better)
    (s.child_share_2024 - b.min_child)
        / NULLIF(b.max_child - b.min_child, 0)    AS n_child_share,

    (s.avg_yoy_pct - b.min_yoy)
        / NULLIF(b.max_yoy - b.min_yoy, 0)        AS n_avg_yoy

FROM c1_country_snapshot s
CROSS JOIN bounds b;