-- Exploratory Data Analysis

SELECT * 
FROM layoffs_staging2;


SELECT max(total_laid_off), max(percentage_laid_off)
FROM layoffs_staging2;

SELECT * 
FROM layoffs_staging2
where percentage_laid_off = 1
order by funds_raised_millions DESC;

SELECT company, sum(total_laid_off) 
FROM layoffs_staging2
group by company
order by 2 desc;

select min(`DATE`),	max(`DATE`)	
FROM layoffs_staging2 ;

select country, sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc;

SELECT * 
FROM layoffs_staging2;

select 	year(`date`), sum(total_laid_off)
from layoffs_staging2
group by year ( `date`)
order by 1 desc;

select stage, sum(total_laid_off)
from layoffs_staging2
group by stage
order by 2 desc;

select company, avg(total_laid_off)
from layoffs_staging2
group by company9
order by 2 desc;

select substring(`DATE`,1,7) AS `MONTH`, sum(total_laid_off)
from layoffs_staging2
WHERE substring(`DATE`,1,7)  is NOT NULL
group by `MONTH`
ORDER BY 1  asc ;

WITH  Rolling_Total AS 
(
select substring(`DATE`,1,7) AS `MONTH`, sum(total_laid_off) as total_off
from layoffs_staging2
WHERE substring(`DATE`,1,7)  is NOT NULL
group by `MONTH`
ORDER BY 1  asc 
)
select `MONTH`,total_off,
 sum(total_off) over (order by `MONTH`) as rolling_total
FROM Rolling_Total ;

SELECT company, sum(total_laid_off) 
FROM layoffs_staging2
group by company
order by 2 desc;

SELECT company, year(`date`), sum(total_laid_off) 
FROM layoffs_staging2
group by company, year(`date`)
order by 3 DESC;


WITH Company_Year (company, years, total_laid_off) AS 
(
SELECT company, year(`date`), sum(total_laid_off) 
FROM layoffs_staging2
group by company, year(`date`)
), Company_Year_Rank as
(select *, 
dense_rank()  over (partition by years order by total_laid_off desc) as Ranking
FROM Company_Year
where years is not null
)
SELECT*
FROM Company_Year_Rank
where Ranking <= 5 ;
