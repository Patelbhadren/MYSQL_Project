use world_layoffs;

SELECT * FROM layoffs_staging2;

SELECT MAX(total_laid_off)
FROM layoff_stagging;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

SELECT * FROM layoffs_staging2
WHERE percentage_laid_off=1;

SELECT * FROM layoffs_staging2
WHERE percentage_laid_off=1
ORDER BY total_laid_off DESC;

SELECT * FROM layoffs_staging2
WHERE percentage_laid_off=1
ORDER BY funds_raised_millions DESC;

SELECT company,SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT MIN('date'), MAX('date')
FROM layoffs_staging2;

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

SELECT 'date', SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY 'date'
ORDER BY 2 DESC;


SELECT year('date'), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY year('date')
ORDER BY 1 DESC;

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 1 DESC;

SELECT company, SUM(percentage_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT SUBSTRING('date',6,2) AS  'month' , SUM(total_laid_off)
FROM layoff_stagging
GROUP BY 'month';

SELECT SUBSTRING('date',1,7) AS  'month' , SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING('date',1,7) IS NOT NULL
GROUP BY 'month'
ORDER BY 1 ASC;

WITH Rolling_Total AS (
    SELECT SUBSTRING(date, 1, 7) AS month, SUM(total_laid_off) AS total_laid_off
    FROM layoffs_staging2
    WHERE SUBSTRING(date, 1, 7) IS NOT NULL
    GROUP BY month
    ORDER BY month ASC
)
SELECT * 
FROM Rolling_Total;

SELECT 
    month,
    total_laid_off,
    SUM(total_laid_off) OVER (ORDER BY month) AS Rolling_Total
FROM (
    SELECT SUBSTRING(date, 1, 7) AS month, SUM(total_laid_off) AS total_laid_off
    FROM layoffs_staging2
    WHERE SUBSTRING(date, 1, 7) IS NOT NULL
    GROUP BY month
) AS Rolling_Total;


SELECT company, 'date',SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company,YEAR('date');

SELECT company, 'date',SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company,YEAR('date')
ORDER BY company ASC;

SELECT company, 'date',SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company,YEAR('date')
ORDER BY 3 DESC;

WITH company_year AS (
    SELECT 
        company, 
        EXTRACT(YEAR FROM date) AS year, 
        SUM(total_laid_off) AS total_laid_off
    FROM layoffs_staging2
    GROUP BY company, EXTRACT(YEAR FROM date)
)
SELECT 
    company, 
    year, 
    total_laid_off,
    DENSE_RANK() OVER (PARTITION BY year ORDER BY total_laid_off DESC) AS Ranking
FROM company_year
WHERE year IS NOT NULL
ORDER BY year, Ranking ASC;
















