-- Data Cleaning 


select *
from layoffs;

-- 1. Remove Duplicates
-- 2. standardize the data
-- 3. null values or blank values
-- 4. remove any columns or rows 

create table layoffs_staging
like layoffs;


select *
from layoffs_staging;

insert layoffs_staging
select *
from layoffs;


select *,
ROW_NUMBER() over(
partition by company, industry, total_laid_off, percentage_laid_off, `date`) as row_num 
from layoffs_staging;


WITH duplicate_cte as
(
select *,
ROW_NUMBER() over(
partition by company,location,
 industry, total_laid_off, percentage_laid_off, `date`, stage, 
 country, funds_raised_millions) as row_num 
from layoffs_staging
)
select *
from duplicate_cte
where row_num > 1;

select *
from layoffs_staging
where company = 'casper';


WITH duplicate_cte as
(
select *,
ROW_NUMBER() over(
partition by company,location,
 industry, total_laid_off, percentage_laid_off, `date`, stage, 
 country, funds_raised_millions) as row_num 
from layoffs_staging
)
delete  
from duplicate_cte
where row_num > 1;




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
  `row_num`  int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


select *
from layoffs_staging2
where row_num > 1 ;

insert into layoffs_staging2 
select *,
ROW_NUMBER() over(
partition by company,location,
 industry, total_laid_off, percentage_laid_off, `date`, stage, 
 country, funds_raised_millions) as row_num 
from layoffs_staging;

delete 
from layoffs_staging2
where row_num > 1 ;

select * 
from layoffs_staging2;

-- standardizing daata 

select company, trim(company)
from layoffs_staging2;

update layoffs_staging2
set company = trim(company);

select distinct industry
from layoffs_staging2;

update layoffs_staging2
set industry = 'crypto'
where industry like 'crypto%';

select distinct country, trim(trailing '.' from country)
from layoffs_staging2
order by 1;

update layoffs_staging2
set country =  trim(trailing '.' from country)
where country like 'united state%';


select `date`date
from layoffs_staging2;


update layoffs_staging2 
SET `DATE` = str_to_date(`date`, '%m/%d/%Y');


ALTER TABLE layoffs_staging2
MODIFY COLUMN `DATE` DATE;

select *
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
where total_laid_off is NULL
AND percentage_laid_off IS NULL ;

update layoffs_staging2
set industry = null
where industry = '';

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL 
OR industry = '';


SELECT *
FROM layoffs_staging2
where company = 'Airbnb';

select ti.industry, t2.industry
from layoffs_staging2  t1
join layoffs_staging2  t2
    on  t1.company = t2.company
    where (t1.industry is null or t1.industry = '') 
    and   t2.industry is not null; 
    
    update layoffs_staging2  t1
    join layoffs_staging2    t2
          on  t1.company = t2.company
	set t1.industry = t2.industry
     where t1.industry is null
    and   t2.industry is not null; 
    
SELECT *
FROM layoffs_staging2;

select *
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

delete
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

select *
from layoffs_staging2;

alter table  layoffs_staging2
drop column row_num ;
