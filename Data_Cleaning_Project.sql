use world_layoffs;

SELECT * FROM layoffs; 

-- 1. Remove Duplicates

CREATE TABLE layoff_stagging
LIKE layoffs;

Select * 
from layoff_stagging;

INSERT layoff_stagging
select *
from layoffs; 

select * from layoff_stagging;

-- Here we try to add a row_num column to identify duplicate

SELECT * ,
ROW_NUMBER() OVER (
PARTITION BY company,location, industry,total_laid_off,percentage_laid_off,'date',stage,country,funds_raised_millions)
AS row_num
FROM layoff_stagging;

WITH duplicate_cte As
( SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location, industry,total_laid_off,percentage_laid_off,'date',stage,country,funds_raised_millions)
AS row_num
FROM layoff_stagging
)

SELECT * 
FROM duplicate_cte
WHERE row_num > 1;

SELECT * 
FROM layoff_stagging 
WHERE company='oda';


SELECT * 
FROM layoff_stagging
WHERE company='casper';

-- we have to delete one of the duplicate not both

DELETE 
FROM duplicate_cte
WHERE row_num > 1;

CREATE TABLE `world_layoffs`.`layoffs_staging2` (
`company` text,
`location`text,
`industry`text,
`total_laid_off` INT,
`percentage_laid_off` text,
`date` text,
`stage`text,
`country` text,
`funds_raised_millions` int,
row_num INT
);

SELECT *
FROM layoffs_staging2;

 INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location, industry,total_laid_off,
percentage_laid_off,'date',stage,country,funds_raised_millions)
AS row_num
FROM layoff_stagging;

SELECT * 
FROM layoffs_staging2
WHERE row_num >1;

SET SQL_SAFE_UPDATES = 0;

DELETE 
FROM layoffs_staging2
WHERE  row_num > 1;

SELECT *
FROM layoffs_staging2;

-- 2 Standardizing the data

SELECT company,TRIM(company)
FROM layoffs_staging2 ;


UPDATE layoffs_staging2
SET company= TRIM(company);


SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY  1;

SELECT * 
FROM layoffs_staging2
WHERE industry like 'crypto%';

UPDATE layoffs_staging2
SET industry= 'crypto%'
WHERE industry like 'crypto%';

SELECT DISTINCT location 
FROM layoffs_staging2
ORDER BY 1;

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

SELECT * 
FROM layoffs_staging2
WHERE country LIKE 'united states'
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'united states';

SELECT 'date',
STR_TO_DATE('date','%m%d%x')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');


ALTER TABLE layoffs_staging2
MODIFY column `date` DATE;

-- 3 Look at null Values

SELECT * 
FROM layoff_stagging;

SELECT * 
FROM layoff_stagging
WHERE total_laid_off IS NULL;

SELECT * 
FROM layoff_stagging
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT DISTINCT industry
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';

SELECT * 
FROM layoffs_staging2
WHERE company= 'Airbnb';

SELECT * 
FROM layoff_stagging  t1
JOIN layoff_stagging  t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE t1.company IS NULL
AND t1.location IS NOT NULL;


SELECT * 
FROM layoff_stagging t1
JOIN layoff_stagging t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE (t1.company IS NULL OR t2.industry = '')
AND t1.location IS NOT NULL; 


SELECT t1.industry, t2.industry
FROM layoff_stagging t1
JOIN layoff_stagging t2
    ON t1.company = t2.company
    AND t1.location = t2.location
WHERE (t1.company IS NULL OR t2.industry = '')
AND t1.location IS NOT NULL;


UPDATE layoff_stagging t1
JOIN layoff_stagging t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;


UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

UPDATE layoff_stagging t1
JOIN layoff_stagging t2
	ON t1.company = t2.comapny
SET t1.industry = t2.industry
WHERE t1.industry IS NULL;

UPDATE layoff_stagging t1
JOIN layoff_stagging t2
    ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL;


-- 4 Remove any column or raw or raw data
SELECT * 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SET SQL_SAFE_UPDATES = 0;
DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


ALTER TABLE layoffs_staging2
DROP COLUMN row_num;



















 
 






