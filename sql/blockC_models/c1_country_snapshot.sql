-- c1_country_snapshot - Base demographic indicators:
-- population growth, volatility, dependency structure and ageing dynamics

WITH cleaned AS (
	SELECT
		country_code,
		year,
		population,
		CAST(NULLIF(REGEXP_REPLACE(age, '[^0-9]', '', 'g'), '') AS INT) AS age_int
	FROM population_history	
	WHERE country_code NOT IN (
      'EU27_2020','EU27_2007','EU28',
      'EA19','EA20','EFTA','EEA30_2007',
      'DE_TOT', 'EEA31')
),

-- agregates yoy
total_population AS (
	SELECT
		country_code,
		year,
		SUM(population) AS total_population
	FROM cleaned
	GROUP BY country_code, year
),

population_yoy AS (
	SELECT
		country_code,
		year,
		total_population,
		total_population - LAG(total_population) OVER (
			PARTITION BY country_code
			ORDER BY year
		) AS yoy_change
	FROM total_population
),

yoy_pct AS (
	SELECT
		country_code,
		year,
		total_population,
		ROUND(1.0 * yoy_change
			/ NULLIF(LAG(total_population) OVER (PARTITION BY country_code ORDER BY year), 0), 3
		) AS yoy_change_pct
	FROM population_yoy
),

yoy_metrics AS (
	SELECT
		country_code,
		ROUND(AVG(yoy_change_pct), 3) AS avg_yoy_pct,
		ROUND(STDDEV_SAMP(yoy_change_pct), 3) AS yoy_volatility
	FROM yoy_pct
	WHERE yoy_change_pct IS NOT NULL
	GROUP BY country_code
),

-- age structure
population_by_age AS (
	SELECT
		country_code,
		year,
		CASE
			WHEN age_int BETWEEN 0 AND 14 THEN 'child'
			WHEN age_int BETWEEN 15 AND 64 THEN 'workforce'
			WHEN age_int >= 65 THEN 'elderly'
		END AS age_group,
		SUM(population) AS population
	FROM cleaned
	GROUP by country_code, year, age_group
),

dependency AS (
	SELECT
		country_code,
		year,
		SUM(population) FILTER (WHERE age_group = 'elderly')
			/ NULLIF(SUM(population) FILTER (WHERE age_group = 'workforce'), 0)
			AS dependency_ratio,
		SUM(population) FILTER (WHERE age_group = 'child')
			/ NULLIF(SUM(population), 0) AS child_share
	FROM population_by_age
	GROUP BY country_code, year
),

dependency_2024 AS (
	SELECT
		country_code,
		ROUND(dependency_ratio, 3) AS dependency_ratio_2024,
		ROUND(child_share, 3) AS child_share_2024
	FROM dependency
	WHERE year = 2024
),

-- derivates ageing
snapshot AS (
	SELECT
		country_code,
		MAX(CASE WHEN year = 2024 THEN dependency_ratio END) AS dr_2024,
		MAX(CASE WHEN year = 2014 THEN dependency_ratio END) AS dr_2014,
		MAX(CASE WHEN year = 2004 THEN dependency_ratio END) AS dr_2004
	FROM dependency
	GROUP BY country_code
),

ageing AS (
	SELECT
		country_code,
		ROUND(dr_2024 - dr_2004, 3) AS ageing_speed,
		ROUND(dr_2024 - dr_2014, 3) AS short_term_speed,
		ROUND((dr_2024 - dr_2014) - (dr_2014 - dr_2004), 3) AS ageing_momentum
	FROM snapshot
)

SELECT
    y.country_code,
    y.avg_yoy_pct,
    y.yoy_volatility,
    d.dependency_ratio_2024,
    d.child_share_2024,
    a.ageing_speed,
    a.ageing_momentum
FROM yoy_metrics y
LEFT JOIN dependency_2024 d USING (country_code)
LEFT JOIN ageing a USING (country_code)
ORDER BY ageing_momentum DESC;