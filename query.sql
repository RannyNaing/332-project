USE  world;
SELECT * FROM City;
SELECT * FROM Country;
SELECT * FROM CountryLanguage;
SELECT * FROM Continent;
SELECT * FROM GDP;
SELECT * FROM TokyoOlympic;

   -- Mega City --
SELECT * FROM City 
WHERE Population > 7000000;

  -- Country with Population Between 50 million and 100 million --
SELECT * FROM country
WHERE Population BETWEEN 50000000 AND 100000000;

  -- Country with 1 billion people or more  --
SELECT * FROM country
WHERE Population  > 1000000000;

    -- City Arranged accordidng to Population
SELECT * FROM City ORDER BY Population DESC;

   --  Country that won most medals --- 
SELECT * FROM tokyoolympic ORDER BY Total DESC;

   -- Asian Country that have long life expectancy --
SELECT * FROM country WHERE  LifeExpectancy > 70 AND Continent = "Asia";

-- Population of each continent using country table --
SELECT continent, SUM(population) FROM Country GROUP BY Continent;

   -- Country that starts with the letter A --
SELECT * FROM country WHERE Name LIKE "A%" ORDER BY Name;

  -- Country and their Continent and which part of the world they are located in --
SELECT Country.Code, Country.Name, Country.Continent, Continent.Hemisphere
FROM Country
Cross JOIN Continent ON Continent.Name=Country.Continent;

    --  Country GDP that has population larger than 100 million  --
SELECT country.code, country.Name, country.Population, country.GNP, GDP.GDP_constant_2015_US
FROM  country
INNER JOIN GDP ON country.Name = GDP.Entity
WHERE country.Population > 100000000;

  -- Cities and where they are located and ordered by Population -- 
SELECT city.Name, city.CountryCode, city.District, country.Name, country.Region, country.Continent, city.Population
From city
LEFT JOIN country ON city.CountryCode = country.Code
ORDER BY city.Population DESC;

    --  Country that speak either English or Spanish  --
SELECT Code, Name, Region, Continent FROM country WHERE (code) IN 
(SELECT DISTINCT CountryCode FROM countrylanguage WHERE language IN ("English", "Spanish"));

 -- Country that uses Spanish as an official language  --
SELECT Code, Name, Region, Continent FROM country WHERE Code IN 
(SELECT DISTINCT CountryCode FROM countrylanguage WHERE Language = "Spanish" and IsOfficial = "T");

  -- Country with GDP larger than EU --
SELECT Entity, Code, GDP_constant_2015_US FROM GDP WHERE GDP_constant_2015_US > (SELECT GDP_constant_2015_US FROM GDP WHERE Entity = "European Union") AND Code LIKE "___"; 


-- Urban and Rural Population of each country  --
SELECT Name, Code , CountryTable.CityPopulation, (country.Population - CountryTable.CityPopulation) AS RuralPopulation
FROM country
INNER JOIN (SELECT CountryCode, SUM(city.population) AS CityPopulation FROM city GROUP BY CountryCode) AS CountryTable
ON country.Code = CountryTable.CountryCode
ORDER BY CityPopulation DESC;

 -- Country That have won Olympic Medals --
SELECT country.Name, country.Code, country.Population, tokyoolympic.Total, tokyoolympic.Rank_by_Total
FROM country
LEFT JOIN tokyoolympic ON tokyoolympic.NOCCode = country.Code
WHERE Total IS NOT NULL;



	   SELECT Rank()OVER (ORDER BY (`GDP_constant_2015_US`) DESC) AS gdpRank,
		      Entity, 
		      Code,
			  -- renaming the gdp column
		      `GDP_constant_2015_US` AS GDP
	   FROM world.GDP
	   WHERE `Code` !=''
       -- and deleting the "World" row and "Kosovo" from the view
	   AND
          `Entity` NOT IN 
          (
           SELECT Entity 
           FROM world.GDP
           WHERE Entity = 'World' OR Entity = 'Kosovo'
		  );   
          
          
          
SELECT gdp.Entity,
	   gdp.code,
       TokyoOlympic.NOCCode,
       gdp.Entity,
       TokyoOlympic.TeamNOC,
	   gdp.GDP_constant_2015_US,
       TokyoOlympic.Total,
       TokyoOlympic.Rank_by_Total
FROM gdp
INNER JOIN TokyoOlympic ON gdp.Code = TokyoOlympic.NOCCode
ORDER BY Total DESC, Rank_by_Total;


SELECT country.Name, country.Code, country.Population, gdp.GDP_constant_2015_US, 
( gdp.GDP_constant_2015_US / country.Population) AS GDP_per_Capita,
Rank()OVER (ORDER BY (gdp.GDP_constant_2015_US / country.Population) DESC) AS GDP_per_Capita_Rank
FROM country
INNER JOIN gdp 
ON country.Name = gdp.Entity;

