-- Exploratory Data Analysis




select *
from layoffs_staging2;


-- Looking at Percentage to gain insight into how large these layoffs were

select max(total_laid_off), max(percentage_laid_off)
from layoffs_staging2
where percentage_laid_off IS NOT NULL;



-- Looking at which companies had 1 which is basically 100 percent of they company laid off, and ordering by funds_raised_millions to see how big some of these companies were

select *
from layoffs_staging2
where percentage_laid_off = 1
order by funds_raised_millions desc
;



select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;


-- Companies with the most Total Layoffs

select country, sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc;


-- Total layoffs per year according to the dataset

select year(`date`), sum(total_laid_off)
from layoffs_staging2
group by year(`date`)
order by 2 desc;


-- Rolling Total of Layoffs Per Month

select substring(`date`,1,7) as `Month`, sum(total_laid_off)
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `Month`
order by 1 ASC;


With Rolling_Total as
( Select substring(`date`,1,7) as `Month`, sum(total_laid_off) as total_laid_off
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `Month`
order by 1 ASC
)
select `Month`, total_laid_off, sum(total_laid_off) over(order by `Month`) as rolling_total
from Rolling_Total;



-- Companies with the most Layoffs per year

select company, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
order by 3 desc;



With Company_Year(company, years, total_laid_off) as 
( select company, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
)
, Company_Year_Rank as
( select *, dense_rank() over(partition by years order by total_laid_off desc) as ranking
From Company_Year
where years is not null
)
select *
from Company_Year_Rank
where ranking <=5;

