# HR-Analysis-SQL-PBI-

###Project Overview

### Data Source
Data - HR Data with over 22000 rows from the year 2000 to 2020.

### Tools

- MySQL Workbench - data Cleaning & Analysis  
- PowerBI -Data Visualization

### Data cleaning and preparation

### Exploratory Data Analysis

```sql
    SELECT gender, COUNT(*) AS count_of_gender
    FROM hr
    WHERE age>=18 AND termdate='0000-00-00'
    GROUP BY gender;
```

```sql
SELECT location_state, COUNT(*) AS count_location
FROM hr
WHERE age >=18 AND termdate = '0000-00-00'
GROUP BY location_state
ORDER BY count_location DESC;
``` 
## Data Analysis
The following questions were explored  to gain insight into the HR data.
- What is the gender breakdown of employees in the company?
- What is the race/ethnicity breakdown of employees in the company?
- What is the age distribution of employees in the company?
- How many employees work at headquarters versus remote locations?
- What is the average length of employment for employees who have been terminated?
- How does the gender distribution vary across departments and job titles?
- What is the distribution of job titles across the company?
- Which department has the highest turnover rate?
- What is the distribution of employees across locations by state?
- How has the company's employee count changed over time based on hire and term dates?
- What is the tenure distribution for each department?

### Summary of Findings
1. There are more male employees

2. White race is the most dominant while Native Hawaiian and American Indian are the least dominant.

3. The youngest employee is 20 years old and the oldest is 57 years old

4. 5 age groups were created (18-24, 25-34, 35-44, 45-54, 55-64). A large number of employees were between 25-34 followed by 35-44 while the smallest group was 55-64.

5. A large number of employees work at the headquarters versus remotely.

6. The average length of employment for terminated employees is around 8 years.

7. The gender distribution across departments is fairly balanced but there are generally more male than female employees.

8. The Marketing department has the highest turnover rate followed by Training. The least turn over rate are in the Research and development, Support and Legal departments.

9. A large number of employees come from the state of Ohio.

10. The net change in employees has increased over the years.

11. The average tenure for each department is about 8 years with Legal and Auditing having the highest and Services, Sales and Marketing having the lowest.


# Limitations

Some records had negative ages and these were excluded during querying(967 records). Ages used were 18 years and above.

Some termdates were far into the future and were not included in the analysis(1599 records). The only term dates used were those less than or equal to the current date.
