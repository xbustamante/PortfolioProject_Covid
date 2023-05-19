
--GUIDED PROJECT
--Exploratory Analysis 

--Total cases vs Total deaths (USA)
SELECT 
location,
date,
cast(total_deaths as int),
total_cases,
(total_deaths/total_cases)*100 as DeathPercentage,
population
FROM PortfolioProject.dbo.CovidDeaths$
where continent is not null AND 
location like '%states%'
ORDER BY 1,2

--Total Cases vs. Population (USA) 
SELECT 
location,
date,
total_deaths,
total_cases,
population,
round((total_cases/population)*100,2) as PercentageofInfectedPop
FROM PortfolioProject.dbo.CovidDeaths$
where continent is not null AND 
location like '%states%'
ORDER BY 1,2

--Countries with highest infection rate 
SELECT 
location,
max(total_cases) AS HighestInfCount,
population,
max(round((total_cases/population)*100,2)) as HighestPerct
FROM PortfolioProject.dbo.CovidDeaths$
WHERE continent is not null
GROUP BY location, population
ORDER BY 4 DESC


--Countries with highest death rate by population
SELECT
location,
max(cast(total_deaths as int)) as TotalDeaths,
max(population) as TotalPop,
round(MAX((cast(total_deaths as int)/population))*100,4) as TotalDeathPerc
FROM PortfolioProject.dbo.CovidDeaths$
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathPerc DESC

--BY CONTINENT 
--issues with the data 
SELECT
continent,
max(cast(total_deaths as int)) as TotalDeaths,
max(population) as TotalPop
FROM PortfolioProject.dbo.CovidDeaths$
WHERE continent is not null
GROUP BY continent
order by TotalDeaths DESC

--Total cases vs Total deaths (Continent)
SELECT 
continent,
date,
cast(total_deaths as int),
total_cases,
(total_deaths/total_cases)*100 as DeathPercentage,
population
FROM PortfolioProject.dbo.CovidDeaths$
where continent is not null
--location like '%states%'--
ORDER BY 1,2

--Total Cases vs. Population (Continents) 
SELECT 
continent,
date,
total_deaths,
total_cases,
population,
round((total_cases/population)*100,2) as PercentageofInfectedPop
FROM PortfolioProject.dbo.CovidDeaths$
where continent is not null 
--location like '%states%'
ORDER BY 1,2

--Continents with highest infection rate 
SELECT 
continent,
max(total_cases) AS HighestInfCount,
population,
max(round((total_cases/population)*100,2)) as HighestPerct
FROM PortfolioProject.dbo.CovidDeaths$
WHERE continent is not null
GROUP BY continent, population
ORDER BY 4 DESC

--Continents with highest death rate by population
SELECT
continent,
max(cast(total_deaths as int)) as TotalDeaths,
max(population) as TotalPop,
round(MAX((cast(total_deaths as int)/population))*100,4) as TotalDeathPerc
FROM PortfolioProject.dbo.CovidDeaths$
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathPerc DESC

--Global Calculations 
SELECT 
date,
sum(new_cases) as TotalCases, 
sum(cast(new_deaths as int)) as TotalDeaths,
(sum(cast(new_deaths as int))/sum(new_cases))*100 as DeathPerc
FROM PortfolioProject.dbo.CovidDeaths$
where continent is not null
group by date
--location like '%states%'--
ORDER BY 1

SELECT 
sum(new_cases) as TotalCases, 
sum(cast(new_deaths as int)) as TotalDeaths,
(sum(cast(new_deaths as int))/sum(new_cases))*100 as DeathPerc
FROM PortfolioProject.dbo.CovidDeaths$
where continent is not null
--location like '%states%'--
ORDER BY 1


--Covid Vacc

--Total Population Vs Vaccination 

Select d.continent,
d.location,
d.date,
v.total_vaccinations,
v.new_vaccinations,
d.population,
((convert(int, v.new_vaccinations))/d.population)*100 as VaccPopRate
From PortfolioProject.dbo.CovidDeaths$ d 
JOIN PortfolioProject.dbo.CovidVaccinations$ v
ON d.location=v.location AND d.date=v.date
WHERE d.continent is not null
ORDER BY 1,2,3

--rolling count of vaccionations 
With PopVacc as 
(Select d.continent,
d.location,
d.date,
v.new_vaccinations,
d.population,
SUM(cast(v.new_vaccinations as int)) OVER(partition by v.location Order by v.location, v.date) as RollingVaccs
From PortfolioProject.dbo.CovidDeaths$ d 
JOIN PortfolioProject.dbo.CovidVaccinations$ v
ON d.location=v.location AND d.date=v.date
WHERE d.continent is not null) 

Select continent,
location,
date,
population,
new_vaccinations,
RollingVaccs,
round((RollingVaccs/population) * 100,4) as PercPopVacc
From PopVacc
where RollingVaccs is not null
ORDER BY 2,3


--Create view for visuals 

Create view PercentPopVacc as 
Select d.continent,
d.location,
d.date,
v.new_vaccinations,
d.population,
SUM(cast(v.new_vaccinations as int)) OVER(partition by v.location Order by v.location, v.date) as RollingVaccs
From PortfolioProject.dbo.CovidDeaths$ d 
JOIN PortfolioProject.dbo.CovidVaccinations$ v
ON d.location=v.location AND d.date=v.date
WHERE d.continent is not null

