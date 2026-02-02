-- Relative year-over-year population change (%)
-- Normalized by previous year's population

DROP TABLE IF EXISTS population_yoy_pct;

CREATE TABLE population_yoy_pct AS
SELECT
    country_code,
    year,
    total_population,
    yoy_change,
    ROUND(
        100.0 * yoy_change
        / LAG(total_population) OVER (
            PARTITION BY country_code
            ORDER BY year
        ),
        3
    ) AS yoy_change_pct
FROM population_yoy
WHERE yoy_change IS NOT NULL;