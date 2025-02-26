/*

World Layoffs Data EDA 

*/

-- Displaying data
SELECT *
FROM layoffs_staging2;

-- MAX total laid off and percentage laid off
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

-- Companies that laid off 100% of employees
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1;

-- Liquidated companies with the highest number of laid off employees
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

-- Liquidated companies with the highest funding amount
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- Total number of employees laid off per company
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- The earliest and latest recorded layoff dates
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

-- Total number of layoffs per country
SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT *
FROM layoffs_staging2;

-- Total number of layoffs per year
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

-- Total number of layoffs for each company stage
SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

-- Average percentage of employees laid off per company
SELECT company, AVG(percentage_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- Total number of layoffs for each month
SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;

--  Rolling total of layoffs over time by month
WITH Rolling_Total AS 
(
SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, 
	total_off,
    SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;

-- Total number of layoffs per company
SELECT company,
	SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- Total number of layoffs per company for each year
SELECT company,
	YEAR(`date`),
	SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

-- Total number of layoffs per company by year. Ranks the companies within each year based on the total layoffs, and returns the top 5 companies with the most layoffs for each year.
WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company,
	YEAR(`date`),
	SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS
(
SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5;







