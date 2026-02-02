CREATE OR REPLACE VIEW c5_population_forecast_2050 AS
WITH base AS (
    SELECT
        country_code,
        year,
        SUM(population) AS total_population
    FROM population_history
    WHERE country_code NOT IN (
        'EU27_2020','EU27_2007','EU28',
        'EA19','EA20','EFTA','EEA30_2007',
        'DE_TOT','EEA31'
    )
    GROUP BY country_code, year
),

trend AS (
    SELECT
        country_code,
        REGR_SLOPE(total_population, year) AS slope,
        REGR_INTERCEPT(total_population, year) AS intercept
    FROM base
    WHERE year BETWEEN 2000 AND 2024
    GROUP BY country_code
),

forecast AS (
    SELECT
        t.country_code,
        (t.slope * 2025 + t.intercept) AS pop_2025,
        (t.slope * 2050 + t.intercept) AS pop_2050
    FROM trend t
)

SELECT
    country_code,
    ROUND(
        (
            (pop_2050 - pop_2025)
            / NULLIF(pop_2025, 0)
        )::numeric,
        3
    ) AS forecast_pop_change_2025_2050
FROM forecast;