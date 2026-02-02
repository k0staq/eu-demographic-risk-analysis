WITH cleaned AS (
	SELECT
		country_code,
		year,
		population,
		CAST(
			NULLIF(REGEXP_REPLACE(age, '[^0-9]', '', 'g'), '') AS INT) AS age_int
	FROM population_history
),
age_buckets AS (
	SELECT
		country_code,
		year,
		population,
		age_int,
		CASE
			WHEN age_int BETWEEN 0 AND 14 THEN 'child'
			WHEN age_int BETWEEN 15 AND 64 THEN 'workforce'
			WHEN age_int >= 65 THEN 'elderly'
			ELSE 'unknown'
		END AS age_group
	FROM cleaned
	WHERE age_int IS NOT NULL
),
aggregated AS (
	SELECT
		country_code,
		year,
		SUM(population) FILTER (WHERE age_group = 'elderly') AS elderly_population,
		SUM(population) FILTER (WHERE age_group = 'workforce') AS workforce_population
	FROM age_buckets
	GROUP by country_code, year
),
dependency_ratio AS (
    SELECT
        country_code,
        year,
        elderly_population::NUMERIC / workforce_population AS dependency_ratio
    FROM aggregated
    WHERE elderly_population IS NOT NULL
      AND workforce_population IS NOT NULL
),
snapshot AS (
	SELECT
		country_code,
		MAX(CASE WHEN year = 2004 THEN dependency_ratio END) AS dr_2004,
		MAX(CASE WHEN year = 2024 THEN dependency_ratio END) AS dr_2024
	FROM dependency_ratio
	GROUP BY country_code
)
SELECT
	country_code,
	ROUND(dr_2004, 3) AS dependency_ratio_2004,
	ROUND(dr_2024, 3) AS dependency_ratio_2024,
	ROUND(dr_2024 - dr_2004, 3) AS ageing_speed
FROM snapshot
WHERE dr_2004 IS NOT NULL
	AND dr_2024 IS NOT NULL
  	AND country_code NOT IN (
      'EU27_2020','EU27_2007','EU28',
      'EA19','EA20','EFTA','EEA30_2007',
      'DE_TOT'
  )
ORDER BY ageing_speed DESC;