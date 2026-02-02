CREATE VIEW d2_dependency_and_workforce AS
SELECT
    country_code,
    year,
    dependency_ratio,
    workforce_support
FROM c8_dependency_and_workforce
WHERE year BETWEEN 2000 AND 2025;