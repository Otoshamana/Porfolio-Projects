
Select * 
From PortfolioPoject_CovidVirus..[Corona Deaths]
Where continent is not null
Order by 3,4


--Select * 
--From PortfolioPoject_CovidVirus..[Corona Vaccinations]
--Order by 3,4

--Select Data that we are going to use


Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioPoject_CovidVirus..[Corona Deaths]
Where continent is not null
Order by 1,2


-- Looking at total cases vs total deaths 
-- Shows likelihood of dying if you get covid
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
From PortfolioPoject_CovidVirus..[Corona Deaths]
Where location like '%Georgia%' and continent is not null
Order by 1,2


-- Looking at total cases vs Population
-- Shows what percentage of population got covid
Select location, date, total_cases, population, (total_cases/population)*100 as Death_Percentage
From PortfolioPoject_CovidVirus..[Corona Deaths]
Where location like '%Georgia%' and continent is not null
Order by 1,2


-- Looking at countries with infection rate
Select location, MAX(total_cases) as High_infection, population, MAX((total_cases/population))*100 as Max_Death_Percentage
From PortfolioPoject_CovidVirus..[Corona Deaths]
--Where location like '%Georgia%'
Where continent is not null
Group by location, population
Order by Max_Death_Percentage Desc


-- This shows countries with highest death count per population
Select location, MAX(cast(total_deaths as int)) as Total_Death_Count
From PortfolioPoject_CovidVirus..[Corona Deaths]
--Where location like '%Georgia%'
Where continent is not null
Group by location
Order by Total_Death_Count desc


-- Break down by continent
Select continent, MAX(cast(total_deaths as int)) as Total_Death_Count
From PortfolioPoject_CovidVirus..[Corona Deaths]
--Where location like '%Georgia%'
Where continent is not null
Group by continent
Order by Total_Death_Count desc


-- This Shows continets with highest death count per population
Select continent, MAX(cast(total_deaths as int)) as Total_Death_Count
From PortfolioPoject_CovidVirus..[Corona Deaths]
--Where location like '%Georgia%'
Where continent is not null
Group by continent
Order by Total_Death_Count desc


-- Global Numbers
Select date, Sum(new_cases) as total_cases, Sum(cast(new_deaths as int)) as total_deaths, Sum(cast(new_deaths as int))/Sum(new_cases)*100 as global_death_prct  
From PortfolioPoject_CovidVirus..[Corona Deaths]
--Where location like '%Georgia%' 
Where continent is not null
Group by date
Order by 1,2


-- USE CTE

With PopvsVac (Continent, location, date, population, new_vaccinatios, Rolling_people_vaxed) 
as 
(
-- Looking at total poplations vs vaccinations
Select dea.continent, dea.location, dea.date, dea.population, vacc.new_vaccinations,
Sum(Cast(vacc.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location, dea.date) as Rolling_people_vaxed
--, (Rolling_people_vaxed/population)*100
From PortfolioPoject_CovidVirus..[Corona Deaths] dea
Join PortfolioPoject_CovidVirus..[Corona Vaccinations] vacc
	On dea.location = vacc.location
	and dea.date = vacc.date
Where dea.continent is not null
--order by 2,3
)
Select *, (Rolling_people_vaxed/population)*100
From PopvsVac 


--Temp  Table

DROP Table if exists #Pct_Population_Vaxxed
Create Table #Pct_Population_Vaxxed
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
Rolling_people_vaxed numeric
)

Insert into #Pct_Population_Vaxxed
Select dea.continent, dea.location, dea.date, dea.population, vacc.new_vaccinations,
Sum(Cast(vacc.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location, dea.date) as Rolling_people_vaxed
--, (Rolling_people_vaxed/population)*100
From PortfolioPoject_CovidVirus..[Corona Deaths] dea
Join PortfolioPoject_CovidVirus..[Corona Vaccinations] vacc
	On dea.location = vacc.location
	and dea.date = vacc.date
--Where dea.continent is not null
--order by 2,3

Select *, (Rolling_people_vaxed/population)*100
From #Pct_Population_Vaxxed 


--Creating View to Store data for Data viz

Create view PctPopulationVaxxed 
as 
Select dea.continent, dea.location, dea.date, dea.population, vacc.new_vaccinations,
Sum(Cast(vacc.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location, dea.date) as Rolling_people_vaxed
--, (Rolling_people_vaxed/population)*100
	From PortfolioPoject_CovidVirus..[Corona Deaths] dea
	Join PortfolioPoject_CovidVirus..[Corona Vaccinations] vacc
		On dea.location = vacc.location
		and dea.date = vacc.date
Where dea.continent is not null
--order by 2,3

Select * 
From PctPopulationVaxxed





