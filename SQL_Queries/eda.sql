-- intent, age, place, and education have null/missing values

-- For categorical columns, fill the null values with the most common value or replace with 'Other'.
-- For continuous/discrete columns, fill the null values with the average of mean and median value.

-- Find the value that occurs the most in the 'intent' column.
SELECT
    intent,
    COUNT(*) AS count
FROM dbo.gun_deaths
GROUP BY intent
ORDER BY 2 DESC;
-- Fill the NULL values in the 'intent' column with 'Suicide'.
UPDATE dbo.gun_deaths
SET intent = 'Suicide'
WHERE intent IS NULL;

-- Check the range of age to see if there are any values that wouldn't make sense.
SELECT 
    MIN(age) AS age_min,
    MAX(age) AS age_max
FROM dbo.gun_deaths
-- Find the average of the 'age' column's mean and median values rounded to the nearest whole number.
SELECT ROUND((median + mean_age) / 2, 0) AS value
FROM (
    SELECT TOP 1
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY age) OVER() AS median,
        (SELECT AVG(age) FROM dbo.gun_deaths) AS mean_age
    FROM dbo.gun_deaths
) as sub;
-- Fill the NULL values of the 'age' column with the calculated average of mean and median.
UPDATE dbo.gun_deaths
SET age = 43
WHERE age IS NULL;

-- Fill NULL values in the 'place' column with 'Other unspecified'.
UPDATE dbo.gun_deaths
SET place = 'Other unspecified'
WHERE place IS NULL;

-- Fill NULL values in the 'education' column with 'Other'.
UPDATE dbo.gun_deaths
SET education = 'Other'
WHERE education IS NULL;

-- Query the clean data and export the returned table.
SELECT *
FROM dbo.gun_deaths;