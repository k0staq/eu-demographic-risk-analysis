CREATE OR REPLACE VIEW c7_indexed_population AS
WITH base AS (
	SELECT
		population_history.country_code,
		population_history.year,
		sum(population_history.population) AS total_population
	FROM population_history
	WHERE population_history.country_code <> ALL (ARRAY['EU27_2020'::text, 'EU27_2007'::text, 'EU28'::text, 'EA19'::text, 'EA20'::text, 'EFTA'::text, 'EEA30_2007'::text, 'DE_TOT'::text, 'EEA31'::text])
	GROUP BY population_history.country_code, population_history.year
),

base_2000 AS (
	SELECT
		base.country_code,
		base.total_population AS pop_2000
	FROM base
	WHERE base.year = 2000
)

SELECT
	b.country_code,
    b.year,
    round(b.total_population / NULLIF(b0.pop_2000, 0::numeric) * 100::numeric, 1) AS population_index_2000
FROM base b
JOIN base_2000 b0 ON b.country_code = b0.country_code;