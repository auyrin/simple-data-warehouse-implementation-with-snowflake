-- create the date dimension

CREATE OR REPLACE TABLE dwh.public.DATE_DIM(
"date_key"              INT NOT NULL,
"date"                  DATE NOT NULL,
"weekday"               VARCHAR NOT NULL,
"weekday_num"           INT NOT NULL,
"day month"             INT NOT NULL,
"day_of_year"           INT NOT NULL,
"week_of_year"          INT NOT NULL,
"iso_week"       		CHAR(10) NOT NULL,
"month_num"             INT NOT NULL,
"month_name"            VARCHAR(9) NOT NULL,
"month_name_short"  	CHAR(3) NOT NULL,
"quarter"    			INT NOT NULL,
"year"             	    INT NOT NULL,
"first_day_of_month"    DATE NOT NULL,
"last_day_of_month"     DATE NOT NULL,
"yyyymm"                CHAR(7) NOT NULL,
"weekend_indr"          CHAR(10) NOT NULL
);

-- Create a sequence to generate date keys
CREATE OR REPLACE SEQUENCE date_key_seq START = 20190101 INCREMENT = 1;

-- Insert dates from 2019-01-01 to 2030-12-31
INSERT INTO dwh.public.DATE_DIM
SELECT
    date_key_seq.NEXTVAL AS DATE_KEY,
    d AS DATE,
    RTRIM(TO_CHAR(d, 'FMDay')) AS WEEKDAY, -- Trim trailing spaces
    EXTRACT(DOW FROM d) + 1 AS WEEKDAY_NUM,
    EXTRACT(DAY FROM d) AS "DAY MONTH",
    EXTRACT(DOY FROM d) AS day_of_year,
    EXTRACT(WEEK FROM d) AS week_of_year,
    TO_CHAR(d, 'IYYY-IW') AS iso_week,
    EXTRACT(MONTH FROM d) AS month_num,
    RTRIM(TO_CHAR(d, 'FMMonth')) AS month_name, -- Trim trailing spaces
    TO_CHAR(d, 'Mon') AS month_name_short,
    EXTRACT(QUARTER FROM d) AS quarter,
    EXTRACT(YEAR FROM d) AS year,
    DATE_TRUNC('MONTH', d) AS first_day_of_month,
    LAST_DAY(d) AS last_day_of_month,
    TO_CHAR(d, 'YYYYMM') AS yyyymm,
    CASE WHEN EXTRACT(DOW FROM d) IN (0, 6) THEN 'Weekend' ELSE 'Weekday' END AS weekend_indr
FROM (
    SELECT
        DATEADD('day', SEQ4() - 1, '2019-01-01') AS d
    FROM
        TABLE(GENERATOR(ROWCOUNT => 4383))  -- 4383 days from 2019-01-01 to 2030-12-31
) AS dates
WHERE d <= '2030-12-31';

select * from dwh.public.date_dim;

-- this date dimension generated using the generator function needs to be cleaned and transformed.

-- columns to adjust: weekday, monthname


--WEEKDAY FIX
UPDATE dwh.public.DATE_DIM
SET "weekday"= CASE 
                       WHEN "weekday_num" = 1 THEN 'MONDAY'
                       WHEN "weekday_num" = 2 THEN 'TUESDAY'
                       WHEN "weekday_num" = 3 THEN 'WEDNESSDAY'
                       WHEN "weekday_num" = 4 THEN 'THURSDAY'
                       WHEN "weekday_num" = 5 THEN 'FRIDAY'
                       WHEN "weekday_num" = 6 THEN 'SATURDAY'
                       WHEN "weekday_num" = 7 THEN 'SUNDAY'
                       ELSE 'DAY' 
                   END;
                   
--MONTH_name FIX
UPDATE dwh.public.DATE_DIM
SET "month_name" = CASE 
                       WHEN "month_num" = 1 THEN 'JANUARY'
                       WHEN "month_num" = 2 THEN 'FEBUARY'
                       WHEN "month_num" = 3 THEN 'MARCH'
                       WHEN "month_num" = 4 THEN 'APRIL'
                       WHEN "month_num" = 5 THEN 'MAY'
                       WHEN "month_num" = 6 THEN 'JUNE'
                       WHEN "month_num" = 7 THEN 'JULY'
                       WHEN "month_num" = 8 THEN 'AUGUST'
                       WHEN "month_num" = 9 THEN 'SEPTEMBER'
                       WHEN "month_num" = 10 THEN 'OCTOBER'
                       WHEN "month_num" = 11 THEN 'NOVEMBER'
                       WHEN "month_num" = 12 THEN 'DECEMBER'
                       ELSE 'month' 
                   END;

-- i already created the tables for the product dimension (andsales_raw). I loaded the data from my aws s3 bucket.

-- next i would create a payment dimension,and clean/transform the product dimension in our staging area

-- these simple transformations would be done natively on snowflake. however, i'll also practice external transformation techniques in this project.
