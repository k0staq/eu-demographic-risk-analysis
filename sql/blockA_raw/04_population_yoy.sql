-- Year-over-year absolute population change
-- Uses window functions to capture dynamics

DROP TABLE IF EXISTS population_yoy;

CREATE TABLE population_yoy AS
SELECT
    country_code,
    year,
    total_population,
    total_population
        - LAG(total_population) OVER (
            PARTITION BY country_code
            ORDER BY year
        ) AS yoy_change
FROM population_total_year;