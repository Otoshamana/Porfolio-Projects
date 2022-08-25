-- This Querrs's data will be used for Tableau Visualisation project

Select * From PortfolioPoject_CovidVirus..[Corona Deaths]


-- This funtion will tells us total cases, death and % 
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioPoject_CovidVirus..[Corona Deaths]
Where continent is not null
order by 1,2 


-- This data will show how much was total death on all continent 
Select location, SUM(cast(new_deaths as int)) as Total_Death_Count
From PortfolioPoject_CovidVirus..[Corona Deaths]
Where continent is null 
and location not in ('World','European Union','International', 'Upper middle income', 'High income','Lower middle income','Low income')
Group by location
order by Total_Death_Count desc


-- Countries with highest infection rate 
Select location, population, MAX(total_cases) as Highest_InfectionCount,  Max((total_cases/population))*100 as Prct_Population_Infected
From PortfolioPoject_CovidVirus..[Corona Deaths]
Group by location, population
Order by Prct_Population_Infected desc


--  Countries with highest infection rate including new stat date
Select location, population, date, MAX(total_cases) as Highest_InfectionCount,  Max((total_cases/population))*100 as Prct_Population_Infected
From PortfolioPoject_CovidVirus..[Corona Deaths]
Group by Location, Population, date
order by Prct_Population_Infected desc

