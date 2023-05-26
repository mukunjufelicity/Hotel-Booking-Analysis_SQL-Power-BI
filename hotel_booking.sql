SELECT version();

SELECT @@character_set_system;


CREATE DATABASE hotel_booking;

USE hotel_booking;

-- Finding hotel revenue per year and hotel type 
SELECT
    hotel,
    CEILING( -- used CEILING function to round up decimal values
        (
            SELECT
                SUM(CEILING(stays_in_weekend_nights) * CEILING(adr))
                + SUM(CEILING(stays_in_week_nights) * CEILING(adr))
            FROM
                year_2018
            WHERE
                year_2018.hotel = combined_tables.hotel
        )
    ) AS total_revenue_year_2018,
    CEILING(
        (
            SELECT
                SUM(CEILING(stays_in_weekend_nights) * CEILING(adr))
                + SUM(CEILING(stays_in_week_nights) * CEILING(adr))
            FROM
                year_2019
            WHERE
                year_2019.hotel = combined_tables.hotel
        )
    ) AS total_revenue_year_2019,
    CEILING(
        (
            SELECT
                SUM(CEILING(stays_in_weekend_nights) * CEILING(adr))
                + SUM(CEILING(stays_in_week_nights) * CEILING(adr))
            FROM
                year_2020
            WHERE
                year_2020.hotel = combined_tables.hotel
        )
    ) AS total_revenue_year_2020
FROM
    (
        SELECT DISTINCT
            hotel
        FROM
            year_2018
        UNION
        SELECT DISTINCT
            hotel
        FROM
            year_2019
        UNION
        SELECT DISTINCT
            hotel
        FROM
            year_2020
    ) AS combined_tables;
    
-- Merging market segment and meal cost
CREATE TEMPORARY TABLE bookings_temp_table -- created a temporary table to combine hotel records from 2018, 2019, 2020
SELECT *
FROM year_2018
UNION
SELECT *
FROM year_2019
UNION
SELECT *
FROM year_2020;

SELECT * FROM bookings_temp_table -- used left join to facotr in market_segment and meal_cost to the temp table
LEFT JOIN market_segment$ ON bookings_temp_table.market_segment = market_segment$.market_segment
LEFT JOIN meal_cost$ ON meal_cost$.meal = bookings_temp_table.meal;

