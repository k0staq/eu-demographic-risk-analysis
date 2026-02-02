CREATE VIEW d3_indexed_population_full AS
SELECT
    country_code,
    year,
    population_index,
    data_type
FROM c10_indexed_population_full;