/*

Cleaning Data in SQL Queries

*/

SELECT *
FROM layoffs;

-------------------------------------------------------------------------------------------------------------

-- Creating staging table to manipulate instead of manipulating the raw data.

CREATE TABLE layoffs_staging
LIKE layoffs;

-- Insert raw data into staging table.
INSERT layoffs_staging
SELECT *
FROM layoffs;

-------------------------------------------------------------------------------------------------------------

-- Identifying duplicates

WITH duplicate_CTE AS
(
SELECT *,
	ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_CTE
WHERE row_num > 1;

-- Creating another staging table to remove duplicates
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Insert values into table
-- Assigning row numbers to help identify duplicates
INSERT INTO layoffs_staging2
SELECT *,
	ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

-- Identifying duplicates
SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

-- Deleting duplicates
DELETE
FROM layoffs_staging2
WHERE row_num > 1;

-------------------------------------------------------------------------------------------------------------

-- Standardizing data

SELECT company,
	TRIM(company)
FROM layoffs_staging2;

-- Trimming any whitespace from company name
UPDATE layoffs_staging2
SET company = TRIM(company);

-- Cleaning crypto industry values
SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- Cleaning United States country
SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- Converting date from text to datetime
SELECT `date`,
	STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-------------------------------------------------------------------------------------------------------------

-- Addressing null and blank values values

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

-- Changing blank industry values to null
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL;

SELECT *
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company AND t1.location = t2.location
WHERE t1.industry IS NULL 
	AND t2.industry IS NOT NULL;

-- Updating null industry values with the industry of same company that is not null
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL 
	AND t2.industry IS NOT NULL;

-- Deleting useless entries
DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL 
	AND percentage_laid_off IS NULL;

-- Deleting the row number column since it is no longer needed    
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

-- Final cleaned data
SELECT *
FROM layoffs_staging2;










