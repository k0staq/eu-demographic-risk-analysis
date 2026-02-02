-- Raw ingestion table for Eurostat DEMO_PJAN (CSV 2.0)
-- Purpose: store unprocessed demographic data as received

DROP TABLE IF EXISTS raw_demo_pjan;

CREATE TABLE raw_demo_pjan (
    c1  TEXT, c2  TEXT, c3  TEXT, c4  TEXT, c5  TEXT,
    c6  TEXT, c7  TEXT, c8  TEXT, c9  TEXT, c10 TEXT,
    c11 TEXT, c12 TEXT, c13 TEXT, c14 TEXT, c15 TEXT,
    c16 TEXT, c17 TEXT, c18 TEXT, c19 TEXT, c20 TEXT,
    c21 TEXT
);


