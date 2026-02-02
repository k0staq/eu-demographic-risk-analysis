CREATE OR REPLACE VIEW c9_indexed_population_forecast AS
WITH base_2024 AS (
	SELECT
		c7_indexed_population.country_code,
		c7_indexed_population.population_index_2000 AS index_2024
	FROM c7_indexed_population
	WHERE c7_indexed_population.year = 2024
),

years AS (
	SELECT generate_series(2025, 2050) AS year
)

SELECT
	b.country_code,
    y.year,
    round(b.index_2024 * (1::numeric + f.forecast_pop_change_2025_2050 * (y.year - 2024)::numeric / 26::numeric), 2) AS population_index,
    'Forecast'::text AS data_type
FROM base_2024 b
JOIN c6_risk_vs_future_decline f ON b.country_code = f.country_code
CROSS JOIN years y;