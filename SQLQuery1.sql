Select * from PortfolioProject..[covid deaths (2)] order by 3,4

Select * from PortfolioProject..[covid deaths (2)] 
where continent is not NULL 
order by 3,4


Select * from PortfolioProject..[covid vaccinations] order by 3,4

--data we will be using

Select location, date,total_cases, new_cases,total_deaths,population
from PortfolioProject..[covid deaths (2)]
order by 1,2

--total_cases vs total_deaths

Select location, date,total_cases, new_cases,total_deaths , 
((total_deaths/total_cases)*100) as death_perentage
from PortfolioProject..[covid deaths (2)]
order by 1,2

Select location, date,total_cases, new_cases,total_deaths , 
((total_deaths/total_cases)*100) as death_perentage 
from PortfolioProject..[covid deaths (2)]
where location = 'India' or location like '%states%' 
--How to use an alias in where statement
order by 1,2

--looking at countries with highest infection rate compared to population
--(use gropu by always when you use aggregate function)
select location , population ,MAX(total_cases) as HighInfCount ,
MAX((total_cases/population)*100) as PopulationInfected
from PortfolioProject..[covid deaths (2)]
--where location = 'Andorra'
GROUP BY location,population
order by PopulationInfected desc

--highest death count per population
--total_deaths col is declared as char so we need to cast it as int 
select location , population ,MAX(cast(total_deaths as int)) as TotalDeaths ,
MAX((cast(total_deaths as int)/population)*100) as DeathsPerPopulation
from PortfolioProject..[covid deaths (2)]
--where location = 'Andorra'
GROUP BY location,population
order by DeathsPerPopulation desc

select location ,MAX(cast(total_deaths as int)) as TotalDeaths ,
MAX((cast(total_deaths as int)/population)*100) as DeathsPerPopulation
from PortfolioProject..[covid deaths (2)]
--where location = 'Andorra'
where continent is null
GROUP BY location
order by DeathsPerPopulation desc


select continent ,MAX(cast(total_deaths as int)) as TotalDeaths ,
MAX((cast(total_deaths as int)/population)*100) as DeathsPerPopulation
from PortfolioProject..[covid deaths (2)]
--where continent is not null
GROUP BY continent
order by DeathsPerPopulation desc

--showing the continent with highest death count

select continent ,MAX(cast(total_deaths as int)) as TotalDeaths ,
MAX((cast(total_deaths as int)/population)*100) as DeathsPerPopulation
from PortfolioProject..[covid deaths (2)]
where continent is not null
GROUP BY continent
order by DeathsPerPopulation desc

--Global numbers
select sum(new_cases) as total_cases, sum(cast(new_deaths as int ))as total_deaths,
(sum(cast(new_deaths as int ))/sum(new_cases))*100 as TotalDeathPercent
from PortfolioProject..[covid deaths (2)]
--where continent is not null 


--Total Population vs Total Population Vaccinated
--joining two datasets:
select *
from PortfolioProject..[covid deaths (2)] da
join PortfolioProject..[covid vaccinations] va
on da.location = va.location
and da.date = va.date

select da.location,da.date,va.location,va.date 
from PortfolioProject..[covid deaths (2)] da
join PortfolioProject..[covid vaccinations] va
on da.location = va.location
and da.date = va.date

select da.continent,da.location,da.date,da.population,va.new_vaccinations
from PortfolioProject..[covid deaths (2)] da
join PortfolioProject..[covid vaccinations] va
on da.location = va.location
and da.date = va.date
where da.continent is not null
order by 3,5 

--looking at total population vs Vaccinations:
--set ansi_warnings off
--go
select da.continent,da.location,da.date,da.population,va.new_vaccinations,
SUM(cast (va.new_vaccinations as bigint)) over (partition by da.location order by da.location,da.date) 
as increasing_Count_vaccines
-- the PARTITION above line in query adding(componding) up the total vaccination based on location and then resetting again for the new location occurance, run the query for better understanding
from PortfolioProject..[covid deaths (2)] da
join PortfolioProject..[covid vaccinations] va
on da.location = va.location
and da.date = va.date
where da.continent  is not null 
order by 2,3


--How many people of the country from the countrys total population are vaccinated

--CTE format
With PopVsVac(continent,location,date,population,new_vaccinations,increasing_Count_vaccines)
as
(
select da.continent,da.location,da.date,da.population,va.new_vaccinations,
SUM(cast (va.new_vaccinations as bigint)) over (partition by da.location order by da.location,da.date) 
as increasing_Count_vaccines
--we cant use increasing_Count_vaccines as it has been just created using alias
--so to use the newly created alias we need to use a CTE or a temp table
from PortfolioProject..[covid deaths (2)] da
join PortfolioProject..[covid vaccinations] va
on da.location = va.location
and da.date = va.date
where da.continent  is not null 
--order by 2,3
)
Select * from PopVsVac


--Temp Table


--creating views to store data for later visualizationns

Create view PercentPopulationVaccinated as
select da.continent,da.location,da.date,da.population,va.new_vaccinations,
SUM(cast (va.new_vaccinations as bigint)) over (partition by da.location order by da.location,da.date) 
as increasing_Count_vaccines
--we cant use increasing_Count_vaccines as it has been just created using alias
--so to use the newly created alias we need to use a CTE or a temp table
from PortfolioProject..[covid deaths (2)] da
join PortfolioProject..[covid vaccinations] va
on da.location = va.location
and da.date = va.date
where da.continent  is not null 
--order by 2,3

Select * from PercentPopulationVaccinated