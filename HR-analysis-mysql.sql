CREATE DATABASE hr_project;

USE hr_project;

SHOW TABLES FROM hr_project;

SELECT * FROM hr;

-- change colomn name
ALTER TABLE hr
CHANGE COLUMN ï»¿id emp_id VARCHAR(20) NULL;

DESCRIBE hr;

SELECT birthdate FROM hr;

SET sql_safe_updates=0;

-- formatting birthdate column

UPDATE hr
SET birthdate = CASE 
	WHEN birthdate LIKE '%/%' THEN DATE_FORMAT(STR_TO_DATE(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
	WHEN birthdate LIKE '%-%' THEN DATE_FORMAT(STR_TO_DATE(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;

SELECT birthdate FROM hr;
DESCRIBE hr;

ALTER TABLE hr
MODIFY COLUMN birthdate DATE;

DESCRIBE hr;
-- Formating hire_date column
UPDATE hr
SET hire_date = CASE
	WHEN hire_date LIKE '%/%' THEN DATE_FORMAT(STR_TO_DATE(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN hire_date LIKE '%-%' THEN DATE_FORMAT(STR_TO_DATE(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;
    
SELECT hire_date FROM hr;
DESCRIBE hr;

ALTER TABLE hr
MODIFY COLUMN hire_date DATE;


-- Formatting column termdate
UPDATE hr
SET termdate = DATE(STR_TO_DATE(termdate, '%Y-%m-%d %H:%i:%s UTC'))
WHERE termdate IS NOT NULL AND termdate !='';

SELECT termdate FROM hr;


UPDATE hr
SET termdate = CASE
    WHEN termdate IS NOT NULL AND termdate != '' 
    THEN DATE(STR_TO_DATE(termdate, '%Y-%m-%d %H:%i:%s UTC'))
    ELSE NULL
END;


UPDATE hr
SET termdate = CASE
    WHEN termdate IS NOT NULL AND termdate != '' 
    THEN DATE(STR_TO_DATE(termdate, '%Y-%m-%d %H:%i:%s UTC'))
    ELSE termdate
END
WHERE termdate IS NOT NULL AND termdate != '';


UPDATE hr
SET termdate = CASE
    WHEN termdate IS NOT NULL AND termdate != '' 
    THEN DATE(STR_TO_DATE(termdate, '%Y-%m-%d %H:%i:%s UTC'))
    ELSE termdate
END
WHERE termdate IS NOT NULL AND termdate != '';

SELECT termdate FROM hr;

DESCRIBE hr;

UPDATE hr
SET termdate = IF(termdate IS NOT NULL AND termdate != '', date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC')), '0000-00-00')
WHERE true;

SELECT termdate from hr;


SET sql_mode = 'ALLOW_INVALID_DATES';

ALTER TABLE hr
MODIFY COLUMN termdate DATE;

-- create new column
ALTER TABLE hr
ADD COLUMN age INT;

SELECT age, birthdate FROM hr;

UPDATE hr
SET age = timestampdiff(YEAR, birthdate, CURDATE());
SELECT
	MIN(age),
    MAX(age)
    FROM hr;
    
    -- Check for outliers in age column
    SELECT COUNT(*) FROM hr
    WHERE age <18;
    
    -- DATA ANALYSIS
    -- 1. what is the gender distribution of the company current employees
    SELECT gender, COUNT(*) AS count_of_gender
    FROM hr
    WHERE age>=18 AND termdate='0000-00-00'
    GROUP BY gender;
    
    -- 2. what is the race distribution of the company
    
    SELECT race, COUNT(*) AS Count_of_race
    FROM hr
    WHERE age>=18 AND termdate='0000-00-00'
    GROUP BY race
    ORDER BY Count_of_race DESC;
    
    -- What is the age and gender  ditribution of the employees
    
    SELECT 
		MIN(age) AS youngest,
		MAX(age) AS oldest
	FROM hr
	WHERE age>=18 AND termdate='0000-00-00';
    
    SELECT
		CASE
        WHEN age>=18 AND age<=24 THEN '18-24'
		WHEN age>=25 AND age<=34 THEN '26-34'
		WHEN age>=35 AND age<=44 THEN '35-44'
		WHEN age>=45 AND age<=54 THEN '45-54'
       WHEN age>=55 AND age<=64 THEN '55-64' 
        ELSE '65+'
	END AS age_group, gender, COUNT(*) AS count
	FROM hr
	WHERE age>=18 AND termdate='0000-00-00'
    GROUP BY age_group, gender
    ORDER BY age_group, gender;
        
    -- how many employees work at headquarters vs remote
    
    SELECT location, COUNT(*) as count_location
    FROM hr
    WHERE age>=18 AND termdate ='0000-00-00'
    GROUP BY location
    ORDER BY count_location DESC;
    
    -- what is the average employment length of employees who have been terminated
    
    SELECT
    ROUND(AVG(DATEDIFF(termdate, hire_date))/365,0) AS avg_years_of_employment
    FROM hr
    WHERE termdate <= CURDATE() AND age >=18 AND termdate <> '0000-00-00'
    
    -- How does gender distribution vary across departments and job titles

	SELECT department, gender, COUNT(*) AS department_count
	FROM hr
	WHERE age >=18 AND termdate = '0000-00-00'
	GROUP BY department, gender
	ORDER BY department, gender;

SELECT department, COUNT(*) AS department_count
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY department
ORDER BY department;

-- what is the distribution of job titles across the company
SELECT jobtitle, COUNT(*) AS count_jobtitle
FROM hr
WHERE age >=18 AND termdate = '0000-00-00'
GROUP BY jobtitle
ORDER BY jobtitle;

-- Which department has the highest turnover rate
SELECT department,
	total_count,
    terminated_count,
    terminated_count/total_count AS terminated_rate
FROM (
	SELECT department,
    COUNT(*) AS total_count,
    SUM(CASE WHEN termdate<> '0000-00-00' AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS terminated_count
    FROM hr
    WHERE age >=18
    GROUP BY department 
    )AS SUBQUERY
ORDER BY terminated_rate DESC;

-- distribution of employees across location by city and state
SELECT location_state, COUNT(*) AS count_location
FROM hr
WHERE age >=18 AND termdate = '0000-00-00'
GROUP BY location_state
ORDER BY count_location DESC;


-- how has the company employess change over the years based on hire and termdate
SELECT
	year,
    hires,
    terminations,
    hires-terminations AS net_termination,
    ROUND((hires-terminations)/hires * 100, 2) AS net_termination_percent
FROM(
	SELECT 
		YEAR(hire_date) AS year,
        COUNT(*) AS hires,
        SUM(CASE WHEN termdate <>'0000-00-00' AND termdate <=CURDATE() THEN 1 ELSE 0 END) AS terminations
        FROM hr
        WHERE age >=18
        GROUP BY YEAR(hire_date)
        )AS subquery
ORDER BY YEAR ASC;
-- what is the tenure distribution for each department
SELECT department, ROUND(AVG(datediff(termdate,hire_date)/365),0) AS avg_tenure
FROM hr
WHERE termdate<=CURDATE() AND termdate <> '0000-00-00' AND age>=18
GROUP BY department;
