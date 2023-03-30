/* 
    lab6.sql 
    Author: Nathan Oliver
    
 */

/***********/
/* Stage 1 */
/***********/

-- clear the workspace
DROP TABLE IF EXISTS uber_report;

-- create the table
CREATE TABLE uber_report (
    distance NUMERIC(5,2),
    time_stamp VARCHAR(26),
    destination TEXT,
    source TEXT,
    price NUMERIC(5,2),
    surge_multiplier NUMERIC(4,2),
    name TEXT,
    id INT,
    PRIMARY KEY (id)
);

-- load the data into the table
\COPY uber_report FROM 'uber_report.csv' WITH (HEADER TRUE, FORMAT csv);


-- sanity-check the data and shape of the table
\d uber_report

SELECT * FROM uber_report LIMIT 5;
SELECT COUNT(*) FROM uber_report;


-- clear the workspace
DROP TABLE IF EXISTS weather_report;

-- create the table
CREATE TABLE weather_report (
    temp NUMERIC(4,2),
    location TEXT,
    clouds NUMERIC(3,2),
    pressure NUMERIC(6,2),
    rain NUMERIC(5,4),
    time_stamp VARCHAR(26),
    humidity NUMERIC(3,2),
    wind  NUMERIC(4,2),
    PRIMARY KEY (time_stamp, location)
);

-- load the data into the table
\COPY weather_report FROM 'weather_report.csv' WITH (HEADER TRUE, FORMAT csv);


-- sanity-check the data and shape of the table
\d weather_report

SELECT * FROM weather_report LIMIT 5;

SELECT COUNT(*) FROM weather_report;

/***********/
/* Stage 2 */
/***********/

-- 2.1 is captured in lab6.pdf, not this script 

-- 2.2


EXPLAIN ANALYZE
SELECT DISTINCT id, source, destination
FROM uber_report ur, weather_report wr
WHERE source = location AND rain > 0.09
AND date(wr.time_stamp) = date(ur.time_stamp);


-- capture screen shot and explanations in lab6.pdf

-- 2.3

-- put your CREATE INDEX statement(s) here:

CREATE INDEX idx_uberid
ON uber_report (id);

CREATE INDEX idx_weatherid
ON weather_report (time_stamp, location);



EXPLAIN ANALYZE
SELECT DISTINCT id, source, destination
FROM uber_report ur, weather_report wr
WHERE source = location AND rain > 0.09
AND date(wr.time_stamp) = date(ur.time_stamp);

-- capture screen shot and explanations in lab6.pdf

-- 2.4

-- put your altered SQL statement here inside EXPLAIN (without ANALYZE!):

EXPLAIN
SELECT DISTINCT id, source, destination
FROM uber_report
WHERE (source, date(time_stamp)) IN(
    SELECT location, date(time_stamp)
    FROM weather_report
    WHERE rain > 0.09
);

-- capture screen shot and explanations in lab6.pdf

