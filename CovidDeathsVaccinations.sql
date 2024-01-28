SELECT*
FROM [PortafolioProject].[dbo].[CovidDeaths]
ORDER BY 3,4

--SELECT*
--FROM [PortafolioProject].[dbo].[CovidVaccinations]
--ORDER BY 3,4
--Select Data tha we are goint to be Using 

SELECT location,date,total_cases,new_cases,total_deaths, population
FROM [PortafolioProject].[dbo].[CovidDeaths]
ORDER BY 1,2

SELECT location,date,total_cases,total_deaths,CONVERT(float,total_deaths)/CONVERT(float, total_cases)*100 as DeathPercentage
FROM [PortafolioProject].[dbo].[CovidDeaths]
WHERE location lIKE '%states%'
ORDER BY 1,2

--- Looking at total cases vs Population
SELECT location,date,Population,total_cases,CONVERT(float,total_cases)/CONVERT(float, population)*100 as DeathPercentage  
FROM [PortafolioProject].[dbo].[CovidDeaths]
WHERE total_cases is NOT NULL 
ORDER BY 1,2

--looking Cuntries with Highest infection Rate compared to Population
SELECT location,Population,MAX(total_cases) as HighestInfectionCount,MAX(CONVERT(float,total_cases)/CONVERT(float, Population))*100 as PercentPpopulationInfected
FROM [PortafolioProject].[dbo].[CovidDeaths]
WHERE Population  is not null and location='united states'
GROUP BY location, Population
ORDER BY PercentPpopulationInfected desc

--showing the Conuntries Highest Death count per Population
SELECT location,MAX(cast(total_deaths as int)) as TotalDeathCount
FROM [PortafolioProject].[dbo].[CovidDeaths]
WHERE continent  is not null 
GROUP BY location
ORDER BY TotalDeathCount desc

--showing The continent Highest Death count per Population
SELECT continent ,MAX(cast(total_deaths as int)) as TotalDeathCount
FROM [PortafolioProject].[dbo].[CovidDeaths]
WHERE continent  is not null 
GROUP BY continent
ORDER BY TotalDeathCount desc

--showing The continent Highest Death count per Population
SELECT continent ,MAX(cast(total_deaths as int)) as TotalDeathCount
FROM [PortafolioProject].[dbo].[CovidDeaths]
WHERE continent  is not null 
GROUP BY continent
ORDER BY TotalDeathCount desc

GLOBAL NUMBERS

-- Looking at total cases vs Population
SELECT SUM(new_cases ) as TotalCases, SUM(new_deaths) as TotalDeaths, (SUM(new_deaths)/SUM(new_cases)) as DeathPercentage
FROM [PortafolioProject].[dbo].[CovidDeaths]
WHERE continent is NOT NULL 
--GROUP BY date
ORDER BY 1,2
-- uniendo las dos tablas:
SELECT dea.continent, dea.location, dea.date, dea. population, vac.new_vaccinations,
SUM(CONVERT(float, vac.new_vaccinations)) OVER (PARTITION BY dea.location) 
FROM [PortafolioProject].[dbo].[CovidVaccinations] vac
Join [PortafolioProject].[dbo].[CovidDeaths] dea
  ON dea.location=vac.location
   AND vac.date=dea.date
WHERE dea.continent is not null AND vac.new_vaccinations is not null
ORDER BY 1,2,3

 SELECT continent
 FROM PortafolioProject.dbo.CovidVaccinations

 --USE CTE
 
With PopvsVac (Continent,Location,Date,Population,New_Vaccinations)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(float, vac.new_vaccinations)) OVER (PARTITION BY dea.location) 
FROM [PortafolioProject].[dbo].[CovidVaccinations] vac
Join [PortafolioProject].[dbo].[CovidDeaths] dea
	ON dea.location=vac.location
    AND vac.date=dea.date
WHERE dea.continent is not null AND vac.new_vaccinations is not null
--ORDER BY 2,3
)

SELECT*
FROM PopvsVac

--TEMP TABLE
CREATE TABLE #PopulationVac
(Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric
)
INSERT INTO #PopulationVac
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM [PortafolioProject].[dbo].[CovidVaccinations] vac
Join [PortafolioProject].[dbo].[CovidDeaths] dea
	ON dea.location=vac.location
    AND vac.date=dea.date
WHERE dea.continent is not null AND vac.new_vaccinations is not null
--ORDER BY 2,3

SELECT* 
FROM #PopulationVac