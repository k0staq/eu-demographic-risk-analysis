-- A10: Turning points (trend reversals)
WITH trend_sign AS (
    SELECT
        country_code,
        year,
        yoy_change_pct,
        CASE
            WHEN yoy_change_pct > 0 THEN 1
            WHEN yoy_change_pct < 0 THEN -1
            ELSE 0
        END AS trend_sign
    FROM population_yoy_pct
),
sign_change AS (
    SELECT
        country_code,
        year,
        yoy_change_pct,
        trend_sign,
        LAG(trend_sign) OVER (
            PARTITION BY country_code
            ORDER BY year
        ) AS prev_trend_sign
    FROM trend_sign
),
turning_points AS (
    SELECT
        *,
        CASE
            WHEN trend_sign <> prev_trend_sign
                 AND prev_trend_sign IS NOT NULL
            THEN 1 ELSE 0
        END AS is_turning_point
    FROM sign_change
)
SELECT
    country_code,
    year,
    yoy_change_pct,
    CASE
        WHEN trend_sign = 1 THEN 'Upward trend'
        WHEN trend_sign = -1 THEN 'Downward trend'
    END AS new_trend
FROM turning_points
WHERE is_turning_point = 1
ORDER BY country_code, year;


-- A12: Stability score
WITH country_stats AS (
    SELECT
        country_code,
        AVG(yoy_change_pct)        AS avg_yoy_pct,
        STDDEV_SAMP(yoy_change_pct) AS yoy_volatility
    FROM population_yoy_pct
    GROUP BY country_code
    HAVING COUNT(*) >= 20
)
SELECT
    country_code,
    ROUND(avg_yoy_pct, 3)    AS avg_yoy_pct,
    ROUND(yoy_volatility, 3) AS yoy_volatility,
    ROUND(
        ABS(avg_yoy_pct) / NULLIF(yoy_volatility, 0),
        3
    ) AS stability_score
FROM country_stats
ORDER BY stability_score DESC;