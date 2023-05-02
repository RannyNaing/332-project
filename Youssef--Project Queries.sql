USE world;

-- -- Create a view composing relevant data from GDP Table
CREATE OR REPLACE VIEW GDPview AS
	   SELECT Rank()OVER (ORDER BY (GDP_constant_2015_US) DESC) AS RankbyGDP, -- Create a ranking by GDP column.
		      Entity,
		      Code,
		      GDP_constant_2015_US AS GDP -- renaming the gdp column
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

-- Create a view composing relevant data from Olympics Table
CREATE OR REPLACE VIEW OlympicsView AS
	   SELECT country,
              cca3 AS Code,
			  region,
              subregion,
              Pop_Rank,
              totAll AS TotalMedals,
			  OlympicRank
	   FROM world.Olympics;

-- Join GDPview with OlympicsView
CREATE OR REPLACE VIEW GDP_Olympics AS
SELECT gdp.Code AS gCODE,
       O.Code AS oCODE,
       gdp.Entity,
       O.country,
	   gdp.GDP,
       gdp.RankbyGDP,
       O.TotalMedals,
       O.OlympicRank
FROM GDPView AS gdp
INNER JOIN OlympicsView AS O
ON gdp.Code = O.Code
ORDER BY GDP, TotalMedals, OlympicRank;

SELECT * FROM world.GDP;
SELECT * FROM world.GDP_Olympics;
SELECT * FROM world.GDPview;
SELECT * FROM world.OlympicsView;
