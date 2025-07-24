-- Unicorn Boom: Valuation Trends & Emerging Industries in Global Startups, From 2019 - 2021  
-- CHECKING THE TABLES and UPLOADING THE DATASET
SELECT * -- COMPANIES TABLE
FROM companies
LIMIT 5; 
SELECT * -- DATES TABLE
FROM dates 
LIMIT 5;
SELECT *  -- FUNDING TABLE 
FROM funding
LIMIT 5;
SELECT *  -- INDUSRIES TABLE
FROM industries
LIMIT 5;
-- DATA CLEANING AND-NORMALISATION
-- CREATING STAGING TABLES
CREATE TABLE staging_companies -- COMPANIES
LIKE companies;
INSERT INTO staging_companies
SELECT *
FROM companies;
SELECT * FROM staging_companies;
CREATE TABLE staging_dates -- DATES
LIKE dates;
INSERT INTO staging_dates
SELECT *
FROM dates;
SELECT * FROM staging_dates;
CREATE TABLE stage_funding -- FUNDING
LIKE funding;
INSERT INTO stage_funding
SELECT *
FROM funding;
SELECT * FROM stage_funding;
CREATE TABLE stage_industry -- INDUSTRY
LIKE industries;
INSERT INTO stage_industry
SELECT *
FROM industries;
SELECT * FROM stage_industry;
-- CREATING A JOINED TABLE CALLED UNICORN MASTER
CREATE TABLE unicorn_master
SELECT 
    c.company_id,
    c.company AS company_name,
    c.city,
    c.country,
    c.continent,
    d.date_joined,
    d.year_founded,
    f.valuation,
    f.funding,
    i.industry
FROM staging_companies c
JOIN staging_dates d ON c.company_id = d.company_id
JOIN stage_funding f ON c.company_id = f.company_id
JOIN stage_industry i ON c.company_id = i.company_id;
SELECT *
FROM unicorn_master LIMIT 5;

-- 1.	Which industries have the highest total and average unicorn valuations, and how concentrated are those valuations among a few companies?
SELECT industry, SUM(valuation) AS Total_Valuation, AVG(valuation) As Average_Valuation
FROM unicorn_master
GROUP BY industry
ORDER BY Total_Valuation DESC;
SELECT industry, SUM(valuation) AS Total_Valuation, AVG(valuation) As Average_Valuation
FROM unicorn_master
GROUP BY industry
ORDER BY Average_Valuation DESC;
-- 2.	How many unicorn companies were created each year between 2019 and 2021, and how does that trend differ across the top 5 industries?
SELECT year_founded, COUNT(company_name) AS created_entities
FROM unicorn_master
WHERE year_founded IN ('2019', '2020', '2021')
GROUP BY year_founded
ORDER BY year_founded;
-- Count per industry
SELECT industry, COUNT(*) AS total_unicorn
FROM unicorn_master
GROUP BY industry
ORDER BY total_unicorn DESC
LIMIT 5;
-- Distribution per industry
SELECT year_founded, industry, COUNT(company_name) AS created_entities
FROM unicorn_master
WHERE year_founded IN ('2019', '2020', '2021')
  AND industry IN (
    'Fintech',
    'Internet software & services',
    'E-commerce & direct-to-consumer',
    'Artificial intelligence',
    'Health'    
  )
GROUP BY year_founded, industry
ORDER BY industry, year_founded;
-- 3.	Which countries have the most unicorns, and how do their average valuations compare?
SELECT*FROM unicorn_master;
SELECT  country, COUNT(company_name) as No_of_unicorns
FROM unicorn_master
GROUP BY country 
ORDER BY No_of_unicorns DESC
LIMIT 5;
--  Highest average valuation 
SELECT country, avg(valuation) AS avg_val
FROM unicorn_master
WHERE country IN ('United States', 'China' ,'India', 'United Kingdom' , 'Germany')
group by country
ORDER BY avg_val;
-- 4.	What is the average time (in years) from founding to unicorn status, and which industries or countries produce faster unicorns?
SELECT country, 
       ROUND(AVG(YEAR(date_joined) - year_founded), 2) AS avg_years
       FROM unicorn_master
       GROUP BY country
       ORDER BY avg_years ASC;
SELECT industry, 
       ROUND(AVG(YEAR(date_joined) - year_founded), 2) AS avg_years
       FROM unicorn_master
       GROUP BY industry
       ORDER BY avg_years ASC;
-- 5 Which cities host the highest number of unicorns, and are these companies clustered in similar industries?
SELECT city, COUNT(company_name) AS no_of_unicorns
FROM unicorn_master
GROUP BY city
ORDER BY no_of_unicorns DESC
LIMIT 10;

-- Step 1: Creating a temporary table or CTE for the top 10 cities
WITH top_cities AS (
  SELECT city
  FROM unicorn_master
  GROUP BY city
  ORDER BY COUNT(company_name) DESC
  LIMIT 10
)

-- Step 2: Joining this with the main table
SELECT um.city, um.industry, COUNT(um.company_name) AS unicorn_count
FROM unicorn_master um
JOIN top_cities tc ON um.city = tc.city
GROUP BY um.city, um.industry
ORDER BY um.city, unicorn_count DESC;
-- 6.	Which investors most frequently appear among the top-valued unicorns, and in what industries are they investing?
SELECT * 
FROM unicorn_master;
ALTER TABLE unicorn_master 
ADD COLUMN select_investors TEXT;
UPDATE unicorn_master um
JOIN funding f ON um.company_id = f.company_id
SET um.select_investors = f.select_investors;
SELECT select_investors 
FROM unicorn_master
LIMIT 5;
--  Finding Highest Valued Unicorns with Temporary table
CREATE TEMPORARY TABLE top_valued_unicorns AS
SELECT *
FROM unicorn_master
ORDER BY valuation DESC
LIMIT 100; -- Top 100 unicorns
SELECT*
FROM top_valued_unicorns
where industry = 'other';
-- Find the select inetor who's name pitches up the most in this list
SELECT select_investors, count(select_investors) as No_of_investments
FROM unicorn_master
GROUP BY select_investors 
ORDER BY No_of_investments DESC;
-- 7. Which industries have the highest average valuation-to-funding ratio, and what does this suggest about return on investment potential?
SELECT 
  industry,
  ROUND(AVG(valuation / funding), 2) AS avg_valuation_funding_ratio -- Average Ratio
FROM 
  unicorn_master
WHERE 
  funding IS NOT NULL AND funding != 0  --  Where it is not 0 or null
GROUP BY 
  industry
ORDER BY 
  avg_valuation_funding_ratio DESC;
-- 8.	Which industries saw the greatest number of new unicorns join the list in 2020 and 2021, and what global factors might have driven this growth?
SELECT *
FROM unicorn_master;
SELECT industry, COUNT(company_name) as new_unicorn
FROM unicorn_master
WHERE year_founded IN (2019, 2020)
GROUP BY industry
ORDER BY new_unicorn DESC; 
-- 9.	What is the average funding raised per unicorn per country, and how does that relate to the country’s total number of unicorns
SELECT country, COUNT(company_name) AS total_unicorns -- Total unicorns per country
FROM unicorn_master
GROUP BY country
ORDER BY total_unicorns DESC;

SELECT country, ROUND(AVG(funding), 2) AS avg_funding -- Average FUnding
FROM unicorn_master
GROUP BY country
ORDER BY avg_funding DESC;

SELECT country,				-- United queries
       COUNT(company_name) AS total_unicorns,
       ROUND(AVG(funding), 2) AS avg_funding
FROM unicorn_master
GROUP BY country
ORDER BY avg_funding DESC;
-- 10.	Are newer unicorns (post-2020) valued higher or lower than earlier unicorns, and does this trend vary by industry
SELECT *
FROM unicorn_master;
SELECT AVG(valuation) AS pre_2020_avg_val
FROM unicorn_master
WHERE year_founded < 2020;
SELECT AVG(valuation) AS avg_val_from_2020
FROM unicorn_master
WHERE year_founded >= 2020;
-- INDUSTRY TO INDUSTRY
SELECT 
    industry,
    CASE 
        WHEN year_founded < 2020 THEN 'Pre-2020'
        ELSE '2020 and Beyond'
    END AS time_period,
    AVG(valuation) AS avg_valuation
FROM unicorn_master
GROUP BY industry, time_period
ORDER BY industry, time_period;