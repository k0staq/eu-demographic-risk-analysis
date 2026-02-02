-- Aggregated total population per country and year
-- Base fact table for trend analysis

DROP TABLE IF EXISTS population_total_year;

CREATE TABLE population_total_year AS
SELECT
    country_code,
    year,
    SUM(population) AS total_population
FROM population_history
GROUP BY country_code, year;