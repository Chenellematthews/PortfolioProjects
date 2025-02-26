-- Total energy produced, grouped by each region
SELECT 
  region,
  SUM(net_generation - demand) AS total_energy
FROM intel.energy_data
GROUP BY region
ORDER BY total_energy DESC;

--  Total renewable energy by region
SELECT 
  region,
  SUM(hydropower_and_pumped_storage + wind + solar) AS total_renewable_energy
FROM intel.energy_data
GROUP BY region
ORDER BY total_renewable_energy DESC;

-- Percentage of renewable energy by region
SELECT 
  region,
  ROUND(((SUM(hydropower_and_pumped_storage + wind + solar) / SUM(net_generation)) * 100), 2) AS pct_renewable_energy
FROM intel.energy_data
GROUP BY region
ORDER BY pct_renewable_energy DESC;

-- Calculating the renewable energy generated
SELECT
  date,
  region,
  (hydropower_and_pumped_storage + wind + solar) AS energy_generated_mw,
  'renewable energy' AS energy_type
FROM intel.energy_data;

--  Calculating the fossil fuel energy generated
SELECT
  date,
  region,
  (all_petroleum_products + coal + natural_gas + nuclear + other_fuel_sources) AS energy_generated_mw,
  'fossil fuel' AS energy_type
FROM intel.energy_data;

SELECT
  date,
  region,
  (hydropower_and_pumped_storage + wind + solar) AS energy_generated_mw,
  'renewable energy' AS energy_type
FROM intel.energy_data
UNION
SELECT
  date,
  region,
  (all_petroleum_products + coal + natural_gas + nuclear + other_fuel_sources) AS energy_generated_mw,
  'fossil fuel' AS energy_type
FROM intel.energy_data;

-- Joining additional data in order to reach the best conclusion about the location of the next data center.
SELECT *
FROM intel.power_plants AS p
INNER JOIN intel.energy_by_plant AS e
  ON p.plant_code = e.plant_code;
  
  -- Total number of renewable energy power plants for each region
WITH power_plant_energy AS (SELECT *
FROM intel.power_plants AS p
INNER JOIN intel.energy_by_plant AS e
  ON p.plant_code = e.plant_code)

SELECT
  region,
  COUNT(*) AS n_power_plants
FROM power_plant_energy
WHERE energy_type = 'renewable_energy'
GROUP BY region
ORDER BY n_power_plants DESC;

-- Total number of power plants and total Solar Photovoltaic energy generated per region.
WITH power_plant_energy AS (SELECT *
FROM intel.power_plants AS p
INNER JOIN intel.energy_by_plant AS e
  ON p.plant_code = e.plant_code)

SELECT
  region,
  COUNT(*) AS n_power_plants,
  SUM(energy_generated_mw) AS total_energy
FROM power_plant_energy
WHERE primary_technology = 'Solar Photovoltaic'
GROUP BY region
HAVING COUNT(*) >= 50
ORDER BY total_energy DESC





