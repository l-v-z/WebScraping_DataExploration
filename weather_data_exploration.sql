
--renaming some columns

USE krakow_weather
GO
EXEC sp_rename 'kw.Rain_in' , 'Rain' ,  'COLUMN' ;
EXEC sp_rename 'kw.Wind_mph' , 'Wind' ,  'COLUMN' ;
EXEC sp_rename 'kw.Pressure_mb' , 'Pressure' ,  'COLUMN' ;
GO


--changing temperaure containing columns' data types from tinyint to decimal

ALTER TABLE kw
ALTER COLUMN Temperature DECIMAL(8,2)

ALTER TABLE kw
ALTER COLUMN Low DECIMAL(8,2)

ALTER TABLE kw
ALTER COLUMN High DECIMAL(8,2)


--converting farenheit to celsius in temperature values

UPDATE kw 
SET Temperature = ((Temperature-32)*5/9)


UPDATE kw 
SET Low = ((Low-32)*5/9)


UPDATE kw 
SET High = ((High-32)*5/9)


--changing rain data type to remove unnecessary precision

ALTER TABLE kw
ALTER COLUMN Rain DECIMAL(8,2)

--converting inches to cm in rain column

UPDATE kw 
SET Rain = Rain * 2.54 



--converting 0s to null so that avg can ignore them because although it is possible to have 0 rain, 
--the zeros in our data appear too many times during winter months which is illogical

UPDATE kw SET Rain = NULLIF(Rain, 0)


ALTER TABLE kw
ALTER COLUMN Precipitation TINYINT NULL
UPDATE kw set Precipitation = NULLIF(Precipitation, 0)



SELECT * FROM kw
ORDER BY 1,2


--highest temperature during winter
--lowest temperature during summer
--winter: m == 12, 1, 2
--spring: m == 3, 4, 5
--summer: m == 6, 7, 8
--fall: m == 9, 10, 11



--highest temperature for winter 2018

SELECT MAX(High) as 'Highest temperature during winter 2018'
FROM kw
WHERE MONTH(Date) IN (12, 1, 2)
AND YEAR(Date) = 2018
    

--lowest temperature for summer 2018

SELECT MIN(Low) as 'Lowest temperature during summer 2018'
FROM kw
WHERE MONTH(Date) IN (6, 7, 8)
AND YEAR(Date) = 2018


GO


--using only complete data: 

DROP VIEW IF EXISTS complete_rows


GO


CREATE VIEW complete_rows AS
SELECT * 
FROM kw
WHERE kw.Precipitation IS NOT NULL AND 
      kw.Rain IS NOT NULL AND
      kw.Pressure IS NOT NULL
GO 


SELECT YEAR(Date) AS 'Year', COUNT(*) AS 'Complete Entries'
FROM complete_rows
GROUP BY  YEAR(Date)
ORDER BY  'Year'

--2020 has 152 complete entries so we will be using it to get our percentages of precipitation/rain/pressure

--percentage of year with:
--pressure > 1010 mb
--humidity < 60 %
--temperature > 15 C

--percentage of complete entries where preesure is above 1010 mb

SELECT COUNT(CASE WHEN Pressure > 1010
                  AND YEAR(Date) = 2020
                  THEN 1 ELSE NULL END) *100/ COUNT(*) 
                  AS '% of 2020 where pressure > 1010 mb'
FROM complete_rows


--percentage of 2019 where humidity was below 60 percent


SELECT COUNT(CASE WHEN Humidity < 60
                  AND YEAR(Date) = 2019
                  THEN 1 ELSE NULL END) *100/ COUNT(*) 
                  AS '% of 2019 where humidity < 60 %'
FROM kw


--percentage of 2019 where temperature was above 15 degrees C

      
SELECT COUNT(CASE WHEN Temperature > 15 
                  AND YEAR(Date) = 2019
                  THEN 1 ELSE NULL END) *100/ COUNT(*) 
                  AS '% of 2019 where temperature > 15 C'
FROM kw



--new table :
--averages by month


DROP TABLE IF EXISTS monthly_averages
CREATE TABLE monthly_averages (
    yr SMALLINT,
    mth SMALLINT,
    avg_temperature DECIMAL(8,2),
    avg_precipitation DECIMAL(8,2), 
    avg_rain DECIMAL(8,2),
    avg_wind DECIMAL(8,2),
    avg_humidity DECIMAL(8,2),
    avg_pressure DECIMAL(8,2)
)


--populating the newly created table


INSERT INTO monthly_averages
SELECT YEAR(Date) AS yr, 
       MONTH(Date) AS mth,
       AVG(Temperature) AS avg_temperature,
       AVG(Precipitation) AS avg_precipitation,
       AVG(Rain) AS avg_rain,
       AVG(Wind) AS avg_wind,
       AVG(Humidity) AS avg_humidity,
       AVG(Pressure) AS avg_pressure
FROM kw
GROUP BY YEAR(Date), MONTH(Date)



GO



SELECT * FROM monthly_averages
ORDER BY 1,2

