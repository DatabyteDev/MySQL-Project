-- Data Cleaning
-- https://www.kaggle.com/datasets/swaptr/layoffs-2022




select * 
from world_layoffs.layoffs;


-- Creating a staging table where we will clean the data



Create table world_layoffs.layoffs_staging
like world_layoffs.layoffs; 


select * 
from layoffs_staging;

insert layoffs_staging
select * 
From world_layoffs.layoffs;


-- Removing Duplicates

with duplicate_cte as
( select * ,
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
from world_layoffs.layoffs_staging
)

select * 
from duplicate_cte
where row_num > 1;


CREATE TABLE `world_layoffs`.`layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



select * 
from world_layoffs.layoffs_staging2;


insert into layoffs_staging2
select * ,
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
from world_layoffs.layoffs_staging;



select * 
from world_layoffs.layoffs_staging2
where row_num > 1;


Delete 
from world_layoffs.layoffs_staging2
where row_num > 1;

select * 
from world_layoffs.layoffs_staging2;



-- Standardizing Data


select company, trim(company)
from world_layoffs.layoffs_staging2;

Update world_layoffs.layoffs_staging2
set company = trim(company);


select distinct industry
from world_layoffs.layoffs_staging2
order by 1;


select *
from world_layoffs.layoffs_staging2
where industry like 'Crypto%';

update world_layoffs.layoffs_staging2
set industry = 'Crypto'
where industry like 'Crypto%';



select distinct location
from world_layoffs.layoffs_staging2
order by 1;


select distinct country
from world_layoffs.layoffs_staging2
order by 1;


select distinct country, trim(trailing '.' From country)
from world_layoffs.layoffs_staging2
order by 1;


update world_layoffs.layoffs_staging2
set country = trim(trailing '.' From country)
where country like 'United States%';



select *
from world_layoffs.layoffs_staging2;


select `date`
from world_layoffs.layoffs_staging2;

update world_layoffs.layoffs_staging2
set `date` = str_to_date(`date`, '%m/%d/%Y');

Alter Table layoffs_staging2
modify column `date` Date;



-- Null Values


select *
from world_layoffs.layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

Delete
from world_layoffs.layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;


select *
from world_layoffs.layoffs_staging2;


update world_layoffs.layoffs_staging2
set industry = null
where industry = '';

select t1.industry, t2.industry
from world_layoffs.layoffs_staging2 t1
join world_layoffs.layoffs_staging2 t2
	on t1.company = t2.company
where t1.industry is null
and t2.industry is not null
;


update world_layoffs.layoffs_staging2 t1
join world_layoffs.layoffs_staging2 t2
	on t1.company = t2.company
set t1.industry = t2.industry
where t1.industry is null
and t2.industry is not null
;
 
select *
from world_layoffs.layoffs_staging2
;


Alter Table layoffs_staging2
Drop column row_num;


select *
from world_layoffs.layoffs_staging2;


