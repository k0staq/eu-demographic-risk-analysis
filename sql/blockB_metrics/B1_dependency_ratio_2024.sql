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
)
SELECT
	country_code,
	year,
	age_group,
	SUM(population) AS total_population
FROM age_buckets
WHERE age_int IS NOT NULL AND country_code = 'CZ'
GROUP BY country_code, year, age_group
ORDER BY year DESC;

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
)
SELECT
	country_code,
	year,
	age_group,
	SUM(population) AS workforce_population
FROM age_buckets
WHERE age_int IS NOT NULL 
	AND country_code = 'CZ'
	AND age_group = 'workforce'
GROUP BY country_code, year, age_group
ORDER BY year DESC;

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
),
workforce_population AS (
	SELECT
		country_code,
		year,
		age_group,
		SUM(population) AS workforce_population
	FROM age_buckets
	WHERE age_int IS NOT NULL
		AND country_code = 'CZ'
		AND age_group = 'workforce'
	GROUP BY country_code, year, age_group
),
yoy_change AS (
SELECT
	*,
	workforce_population - LAG(workforce_population) OVER(
		PARTITION BY country_code
		ORDER BY year
	) AS yoy_change
FROM workforce_population
)
SELECT
	*,
	ROUND(
		100.0 * yoy_change
		/ LAG(workforce_population) OVER (
			PARTITION BY country_code
			ORDER BY year
		), 3
	) AS yoy_change_pct
FROM yoy_change
ORDER BY year DESC;

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
elderly_population AS (
	SELECT
		country_code,
		year,
		age_group,
		SUM(population) AS elderly_population
	FROM age_buckets
	WHERE age_group = 'elderly'
	GROUP BY country_code, year, age_group
),
workforce_population AS (
	SELECT
		country_code,
		year,
		age_group,
		SUM(population) AS workforce_population
	FROM age_buckets
	WHERE age_group = 'workforce'
	GROUP BY country_code, year, age_group
)
SELECT
	w.country_code,
	w.year,
	e.elderly_population,
	w.workforce_population,
	ROUND(e.elderly_population::NUMERIC / w.workforce_population, 3) AS dependency_ratio
FROM workforce_population w
JOIN elderly_population e
	ON w.country_code = e.country_code AND w.year = e.year
WHERE w.country_code = 'CZ'
ORDER BY w.year DESC;