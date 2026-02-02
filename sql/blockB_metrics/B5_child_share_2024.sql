WITH cleaned AS (
    SELECT
        country_code,
        year,
        population,
        CAST(
            NULLIF(REGEXP_REPLACE(age, '[^0-9]', '', 'g'), '') AS INT
        ) AS age_int
    FROM population_history
),
age_buckets AS (
    SELECT
        country_code,
        year,
        population,
        CASE
            WHEN age_int BETWEEN 0 AND 14 THEN 'child'
            WHEN age_int BETWEEN 15 AND 64 THEN 'workforce'
            WHEN age_int >= 65 THEN 'elderly'
        END AS age_group
    FROM cleaned
    WHERE age_int IS NOT NULL
),
aggregated AS (
    SELECT
        country_code,
        year,
        SUM(population) FILTER (WHERE age_group = 'child') AS child_population,
        SUM(population) AS total_population
    FROM age_buckets
    GROUP BY country_code, year
),
clean AS (
	SELECT
		country_code,
		child_population,
		total_population
	FROM aggregated
	WHERE year = 2024
		AND child_population IS NOT NULL
		AND total_population IS NOT NULL
),
child_share AS (
    SELECT
        country_code,
        ROUND(child_population::NUMERIC / total_population, 3) AS child_share
    FROM clean
)
SELECT *
FROM child_share
WHERE country_code NOT IN (
      'EU27_2020','EU27_2007','EU28',
      'EA19','EA20','EFTA','EEA30_2007',
      'DE_TOT'
  )
ORDER BY child_share;