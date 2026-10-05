create database zomato_db;
use zomato_db;

## Importing data 

CREATE TABLE zomato (
    RestaurantID BIGINT,
    RestaurantName TEXT,
    CountryCode INT,
    City TEXT,
    Address TEXT,
    Locality TEXT,
    LocalityVerbose TEXT,
    Longitude DECIMAL(12,8),
    Latitude DECIMAL(12,8),
    Cuisines TEXT,
    Currency VARCHAR(100),
    Has_Table_booking VARCHAR(10),
    Has_Online_delivery VARCHAR(10),
    Is_delivering_now VARCHAR(10),
    Switch_to_order_menu VARCHAR(10),
    Price_range INT,
    Votes INT,
    Average_Cost_for_two INT,
    Rating VARCHAR(50),
    Datekey_Opening VARCHAR(20)
);                                         -- created the zomato table

select * from zomato;

LOAD DATA LOCAL INFILE "C:/Users/Vishal/OneDrive/Desktop/EXCELR PROJECTS/PROJECT- 2 (Zomato)/MYSQL/Datasets Used/Zomato.csv"
INTO TABLE zomato
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    RestaurantID,
    RestaurantName,
    CountryCode,
    City,
    Address,
    Locality,
    LocalityVerbose,
    Longitude,
    Latitude,
    Cuisines,
    Currency,
    Has_Table_booking,
    Has_Online_delivery,
    Is_delivering_now,
    Switch_to_order_menu,
    Price_range,
    Votes,
    Average_Cost_for_two,
    Rating,
    Datekey_Opening
);                                       -- imported the data of zomato.csv

SHOW GLOBAL VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;

SELECT COUNT(*) AS Total_Rows
FROM zomato;

CREATE TABLE country_code (
    CountryID INT,
    CountryName VARCHAR(100)
);                                 -- created the table of country_code

select * from country_code;

LOAD DATA LOCAL INFILE 'C:/Users/Vishal/OneDrive/Desktop/EXCELR PROJECTS/PROJECT- 2 (Zomato)/MYSQL/Datasets Used/country_code.csv'
INTO TABLE country_code
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    CountryID,
    CountryName
);                         -- imported the data of country_code.csv

SELECT COUNT(*) AS Total_Countries
FROM country_code;

-- ----------------------------------------------------------------------
## Data cleaning

SELECT RestaurantID,
COUNT(*) AS Total
FROM zomato
GROUP BY RestaurantID
HAVING COUNT(*) > 1;     -- checked whether the restaurantid have duplicates or not

SELECT COUNT(*)
FROM zomato
WHERE RestaurantID IS NULL;   -- checked whether the restaurantid have nulls or not

SELECT COUNT(*)
FROM zomato
WHERE CountryCode IS NULL;  -- checked whether the country_code have nulls or not

SELECT Datekey_Opening
FROM zomato
LIMIT 10;

ALTER TABLE zomato
MODIFY COLUMN Datekey_Opening DATE;     -- datatype changedd from text to date

UPDATE zomato
SET Datekey_Opening = REPLACE(Datekey_Opening, '_', '-');  -- changed the format of date

SELECT
    SUM(RestaurantID IS NULL) AS RestaurantID_Nulls,
    SUM(RestaurantName IS NULL) AS RestaurantName_Nulls,
    SUM(CountryCode IS NULL) AS CountryCode_Nulls,
    SUM(City IS NULL) AS City_Nulls,
    SUM(Cuisines IS NULL) AS Cuisines_Nulls,
    SUM(Rating IS NULL) AS Rating_Nulls
FROM zomato;                                                     -- to check all the columns have nulls or not

DESCRIBE zomato;

-- -------------------------------------------------------------------------
##  Q1 → Build a Country Map Table :-

CREATE TABLE country_map AS
SELECT
    z.RestaurantID,
    z.CountryCode,
    c.CountryName
FROM zomato z
INNER JOIN country_code c
ON z.CountryCode = c.CountryID;       -- created a new table country_map using inner join

SELECT *
FROM country_map
LIMIT 10;

-- --------------------------------------------------------------------
## Q2 → Build Calendar Table :-

CREATE TABLE calendar (
    Datekey DATE PRIMARY KEY,
    Year INT,
    MonthNo INT,
    MonthFullName VARCHAR(20),
    Quarter VARCHAR(2),
    YearMonth VARCHAR(10),
    WeekdayNo INT,
    WeekdayName VARCHAR(20),
    FinancialMonth VARCHAR(5),
    FinancialQuarter VARCHAR(3)
);                                   -- created a new table calendar

INSERT INTO calendar (Datekey)
SELECT DISTINCT Datekey_Opening
FROM zomato
ORDER BY Datekey_Opening;

select * from calendar;

SELECT *
FROM calendar
LIMIT 10;
 
 -- year column: 
 UPDATE calendar
SET Year = YEAR(Datekey);  -- created year column

SELECT Datekey, Year
FROM calendar
LIMIT 10;

-- monthno column:
UPDATE calendar
SET MonthNo = MONTH(Datekey);   -- created monthno column

SELECT Datekey, Year, MonthNo
FROM calendar
LIMIT 10;

-- monthfullname column:
UPDATE calendar
SET MonthFullName = MONTHNAME(Datekey);   -- created monthfullname column

SELECT Datekey,Year, MonthNo, MonthFullName
FROM calendar
LIMIT 10;

-- quarter column:
UPDATE calendar
SET Quarter = CONCAT('Q', QUARTER(Datekey));  -- created quarter column

SELECT Datekey, Year, MonthNo, MonthFullName, Quarter
FROM calendar
LIMIT 10;

-- yearmonth (yyyy-mmm) column:
UPDATE calendar
SET YearMonth = DATE_FORMAT(Datekey, '%Y-%b');  -- created yearmonth column

SELECT Datekey, Year, MonthNo, MonthFullName, Quarter, YearMonth
FROM calendar
LIMIT 10;

-- weekdayno column:
UPDATE calendar
SET WeekdayNo = WEEKDAY(Datekey) + 1;   -- created weekdayno column  (+1 is because monday = 0)

SELECT Datekey, Year, MonthNo, MonthFullName, Quarter, YearMonth, WeekdayNo
FROM calendar
LIMIT 10;

-- weekdayname column: 
UPDATE calendar
SET WeekdayName = DAYNAME(Datekey);   -- created weekdayname column

SELECT Datekey, Year, MonthNo, MonthFullName, Quarter, YearMonth, WeekdayNo, WeekdayName
FROM calendar
LIMIT 10;

-- financialmonth ( April = FM1, May= FM2  …. March = FM12) column:
UPDATE calendar
SET FinancialMonth =
CASE
    WHEN MonthNo >= 4 THEN CONCAT('FM', MonthNo - 3)
    ELSE CONCAT('FM', MonthNo + 9)
END;                                                      -- created financialmonth column

SELECT Datekey, Year, MonthNo, MonthFullName, Quarter, YearMonth, WeekdayNo, WeekdayName, FinancialMonth
FROM calendar
LIMIT 15;

-- financial quarter (quarters based on financial month) column:
UPDATE calendar
SET FinancialQuarter =
CASE
    WHEN MonthNo BETWEEN 4 AND 6 THEN 'FQ1'
    WHEN MonthNo BETWEEN 7 AND 9 THEN 'FQ2'
    WHEN MonthNo BETWEEN 10 AND 12 THEN 'FQ3'
    ELSE 'FQ4'
END;                                                -- created financial quarter

SELECT *
FROM calendar
LIMIT 10;

-- -----------------------------------------------------------------------
## Q3 → Number of Restaurants by City and Country :-

SELECT
    c.CountryName,
    z.City,
    COUNT(z.RestaurantID) AS Restaurant_Count
FROM zomato z
INNER JOIN country_code c
ON z.CountryCode = c.CountryID
GROUP BY
    c.CountryName,
    z.City
ORDER BY
    c.CountryName,
    Restaurant_Count DESC;    -- inner join used for zomato and country_code tables

-- ---------------------------------------------------------------------------------------------
## Q4 → Restaurant Openings by Year, Quarter and Month :-

SELECT
    c.Year,
    c.Quarter,
    c.MonthFullName,
    COUNT(z.RestaurantID) AS Restaurant_Openings
FROM zomato z
INNER JOIN calendar c
ON z.Datekey_Opening = c.Datekey
GROUP BY
    c.Year,
    c.Quarter,
    c.MonthNo,
    c.MonthFullName
ORDER BY
    c.Year,
    c.MonthNo;                 -- inner join used for zomato and calendar tables
    
-- ----------------------------------------------------------------------------------------
## Q5 → Restaurant Count by Ratings :-

SELECT
    CASE
        WHEN Rating >= 1 AND Rating < 2 THEN '1-2'
        WHEN Rating >= 2 AND Rating < 3 THEN '2-3'
        WHEN Rating >= 3 AND Rating < 4 THEN '3-4'
        WHEN Rating >= 4 AND Rating <= 5 THEN '4-5'
    END AS Rating_Bucket,
    COUNT(*) AS Restaurant_Count
FROM zomato
GROUP BY Rating_Bucket
ORDER BY Rating_Bucket;                           -- created the rating bucket

ALTER TABLE zomato
MODIFY COLUMN Rating DECIMAL(2,1);                -- datatype changed (rating - text to decimal)

-- ---------------------------------------------------------------------------------------------------
## Q6 → Price Bucket Analysis :-

SELECT
    Price_Range,
    Price_Bucket,
    COUNT(*) AS Restaurant_Count
FROM
(
    SELECT
        CASE
            WHEN Average_Cost_for_two BETWEEN 0 AND 500 THEN '0-500'
            WHEN Average_Cost_for_two BETWEEN 501 AND 1000 THEN '501-1000'
            WHEN Average_Cost_for_two BETWEEN 1001 AND 3000 THEN '1001-3000'
            ELSE 'Above 3000'
        END AS Price_Range,

        CASE
            WHEN Average_Cost_for_two BETWEEN 0 AND 500 THEN 'Low'
            WHEN Average_Cost_for_two BETWEEN 501 AND 1000 THEN 'Medium'
            WHEN Average_Cost_for_two BETWEEN 1001 AND 3000 THEN 'High'
            ELSE 'Luxury'
        END AS Price_Bucket

    FROM zomato
) AS PriceData

GROUP BY
    Price_Range,
    Price_Bucket

ORDER BY
CASE
    WHEN Price_Bucket = 'Low' THEN 1
    WHEN Price_Bucket = 'Medium' THEN 2
    WHEN Price_Bucket = 'High' THEN 3
    WHEN Price_Bucket = 'Luxury' THEN 4
END;                                               -- created the price bucket

-- -------------------------------------------------------------------------------------
## Q7 → Percentage of Restaurants with Table Booking :-

SELECT
    Has_Table_booking,
    COUNT(*) AS Restaurant_Count,
    CONCAT(
        ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM zomato), 2),
        '%'
    ) AS Percentage
FROM zomato
GROUP BY Has_Table_booking
ORDER BY Has_Table_booking;           -- created percentage and the count of restaurants which has table bookings

-- -------------------------------------------------------------------------------------------------------------------------
## Q8 → Percentage of Restaurants with Online Delivery :-

SELECT
    Has_Online_delivery,
    COUNT(*) AS Restaurant_Count,
    CONCAT(
        ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM zomato), 2),
        '%'
    ) AS Percentage
FROM zomato
GROUP BY Has_Online_delivery
ORDER BY Has_Online_delivery;   -- created percentage and the count of restaurants which has online delivery

-- ---------------------------------------------------------------------------------------------------------------
## KPI's :-

-- KPI 1: Total Restaurants
SELECT COUNT(*) AS Total_Restaurants
FROM zomato;

-- KPI 2: Total Countries
SELECT COUNT(DISTINCT CountryCode) AS Total_Countries
FROM zomato;

-- KPI 3: Total Cities
SELECT COUNT(DISTINCT City) AS Total_Cities
FROM zomato;

-- KPI 4: Average Rating
SELECT ROUND(AVG(Rating), 2) AS Average_Rating
FROM zomato;

-- KPI 5: Average Cost for Two
SELECT ROUND(AVG(Average_Cost_for_two), 2) AS Average_Cost_For_Two
FROM zomato;

-- KPI 6: Restaurants with Table Booking
SELECT COUNT(*) AS Restaurants_With_Table_Booking
FROM zomato
WHERE Has_Table_booking = 'Yes';

-- KPI 7: Restaurants with Online Delivery
SELECT COUNT(*) AS Restaurants_With_Online_Delivery
FROM zomato
WHERE Has_Online_delivery = 'Yes';

-- KPI 8: Distinct Cuisines
SELECT COUNT(DISTINCT Cuisines) AS Distinct_Cuisines
FROM zomato;

-- -----------------------------------------------------------------------
## Extra :-

-- KPI 9: Highest Rated Restaurant
SELECT
    z.RestaurantName,
    c.CountryName,
    z.City,
    z.Rating
FROM zomato z
INNER JOIN country_code c
ON z.CountryCode = c.CountryID
WHERE z.Rating = (
    SELECT MAX(Rating)
    FROM zomato
);

-- KPI 10: Lowest Rated Restaurant
SELECT
    z.RestaurantName,
    c.CountryName,
    z.City,
    z.Rating
FROM zomato z
INNER JOIN country_code c
ON z.CountryCode = c.CountryID
WHERE z.Rating = (
    SELECT MIN(Rating)
    FROM zomato
);

-- KPI 11: Most Expensive Restaurant
SELECT
    z.RestaurantName,
    c.CountryName,
    z.City,
    z.Average_Cost_for_two
FROM zomato z
INNER JOIN country_code c
ON z.CountryCode = c.CountryID
WHERE z.Average_Cost_for_two = (
    SELECT MAX(Average_Cost_for_two)
    FROM zomato
);

-- KPI 12: City with the Highest Number of Restaurants
SELECT
    c.CountryName,
    z.City,
    COUNT(*) AS Restaurant_Count
FROM zomato z
INNER JOIN country_code c
ON z.CountryCode = c.CountryID
GROUP BY
    c.CountryName,
    z.City
ORDER BY
    Restaurant_Count DESC
LIMIT 1;


