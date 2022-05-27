-- (1) = Shows the death percentage of the countries.
select location, date, total_cases, total_deaths, (total_deaths / total_cases)*100 as Death_Percentage
from covid_deaths
order by location;

-- (2) = Shows what percentage of population got Covid-19.
select location, date, total_cases, population, (total_cases / population)*100 as PopulationPercentInfected
from covid_deaths
where location = 'United States'
order by location;

-- (3) Shows how much population is infected of different countries.
select location, MAX(total_cases) as Highest_Cases, population, MAX((total_cases / population))*100 as PopulationPercentInfected
from covid_deaths
group by location
order by PopulationPercentInfected desc;

-- (4) = Shows the highest death count of each country.
select location, MAX(cast(total_deaths AS unsigned)) as Maximum_Deaths
from covid_deaths
where continent != ''
group by location
order by Maximum_Deaths desc;

-- (5) = Continents with highest death count.
select continent, MAX(cast(total_deaths AS unsigned)) as Maximum_Deaths
from covid_deaths
where continent != ''
group by continent
order by Maximum_Deaths desc;

-- (6) = Shows the total world death percentage.
Select SUM(new_cases) as total_cases, SUM(CONVERT(new_deaths, unsigned)) as total_deaths, SUM(CONVERT(new_deaths, unsigned))/SUM(New_Cases)*100 as DeathPercentage
From covid_deaths
where continent is not null; 

-- (7) Shows the percentage of people vaccinated.
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(vac.new_vaccinations, unsigned)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From covid_deaths dea
Join covid_vacc vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by dea.location, dea.date
)
Select *, (RollingPeopleVaccinated/Population)*100 as PercentPeopleVaccinated
From PopvsVac;

-- (8) Highest Infection count of every country on a particular date.
Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From Covid_deaths
Group by Location
order by PercentPopulationInfected desc

