-- Cleaned historical population by age
-- Filters: sex = total, age-level records only

DROP TABLE IF EXISTS population_history;

CREATE TABLE population_history AS
SELECT
    c12 AS country_code,
    CAST(c14 AS INT)     AS year,
    c8                  AS age,
    CAST(c16 AS BIGINT)  AS population
FROM raw_demo_pjan
WHERE
    c10 = 'T'           -- Total (both sexes)
    AND c8 <> 'TOTAL'
    AND c16 IS NOT NULL;