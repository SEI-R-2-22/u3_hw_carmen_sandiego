-- Clue #1: We recently got word that someone fitting Carmen Sandiego's description has been
-- traveling through Southern Europe. She's most likely traveling someplace where she won't be noticed,
-- so find the least populated country in Southern Europe, and we'll start looking for her there.

SELECT name, region, population FROM country WHERE region = 'Southern Europe' ORDER BY population ASC LIMIT 1;
            name              |     region      | population 
-------------------------------+-----------------+------------
Holy See (Vatican City State) | Southern Europe |       1000
(1 row)

-- My Answer
carmen=# SELECT name, region, population FROM country WHERE region = 'Southern Europe' 

             name              |     region      | population 
-------------------------------+-----------------+------------
 Albania                       | Southern Europe |    3401200
 Andorra                       | Southern Europe |      78000
 Bosnia and Herzegovina        | Southern Europe |    3972000
 Spain                         | Southern Europe |   39441700
 Gibraltar                     | Southern Europe |      25000
 Italy                         | Southern Europe |   57680000
 Yugoslavia                    | Southern Europe |   10640000
 Greece                        | Southern Europe |   10545700
 Croatia                       | Southern Europe |    4473000
 Macedonia                     | Southern Europe |    2024000
 Malta                         | Southern Europe |     380200
 Portugal                      | Southern Europe |    9997600
 San Marino                    | Southern Europe |      27000
 Slovenia                      | Southern Europe |    1987800
 Holy See (Vatican City State) | Southern Europe |       1000
(15 rows)


-- Clue #2: Now that we're here, we have insight that Carmen was seen attending language classes in
-- this country's officially recognized language. Check our databases and find out what language is
-- spoken in this country, so we can call in a translator to work with you.
SELECT country.name, country.region, country.population, countrylanguage.language FROM country JOIN countrylanguage ON country.code = countrylanguage.countrycode  WHERE region = 'Southern Europe' ORDER BY country.population ASC LIMIT 1;
            name              |     region      | population | language 
-------------------------------+-----------------+------------+----------
Holy See (Vatican City State) | Southern Europe |       1000 | Italian
(1 row)

-- My answer
carmen=# SELECT * FROM country WHERE name = 'Holy See (Vatican City State)';
carmen=# SELECT * FROM countrylanguage WHERE countrycode = 'VAT';

 countrycode | language | isofficial | percentage 
-------------+----------+------------+------------
 VAT         | Italian  | t          |          0
(1 row)


-- Clue #3: We have new news on the classes Carmen attended – our gumshoes tell us she's moved on
-- to a different country, a country where people speak only the language she was learning. Find out which
--  nearby country speaks nothing but that language.

SELECT country.name, country.region, country.surfacearea, countrylanguage.language FROM country JOIN countrylanguage ON country.code = countrylanguage.countrycode  WHERE countrylanguage.language = 'Italian' ORDER BY country.surfacearea;

            name              |          region           | surfacearea  | language 
-------------------------------+---------------------------+--------------+----------
 Holy See (Vatican City State) | Southern Europe           |          0.4 | Italian
 Monaco                        | Western Europe            |          1.5 | Italian
 San Marino                    | Southern Europe           |           61 | Italian
 Liechtenstein                 | Western Europe            |          160 | Italian
 Luxembourg                    | Western Europe            |         2586 | Italian
 Belgium                       | Western Europe            |        30518 | Italian
 Switzerland                   | Western Europe            |        41284 | Italian
 Italy                         | Southern Europe           |       301316 | Italian
 Germany                       | Western Europe            |       357022 | Italian
 France                        | Western Europe            |       551500 | Italian
 Argentina                     | South America             |   2.7804e+06 | Italian
 Australia                     | Australia and New Zealand |  7.74122e+06 | Italian
 Brazil                        | South America             | 8.547403e+06 | Italian
 United States                 | North America             |  9.36352e+06 | Italian
 Canada                        | North America             |  9.97061e+06 | Italian

 -- My Answer
 SELECT country.name, country.region, countrylanguage.language FROM country JOIN countrylanguage ON country.code = countrylanguage.countrycode  WHERE countrylanguage.language = 'Italian' 

             name              |          region           | language 
-------------------------------+---------------------------+----------
 Argentina                     | South America             | Italian
 Australia                     | Australia and New Zealand | Italian
 Belgium                       | Western Europe            | Italian
 Brazil                        | South America             | Italian
 Italy                         | Southern Europe           | Italian
 Canada                        | North America             | Italian
 Liechtenstein                 | Western Europe            | Italian
 Luxembourg                    | Western Europe            | Italian
 Monaco                        | Western Europe            | Italian
 France                        | Western Europe            | Italian
 Germany                       | Western Europe            | Italian
 San Marino                    | Southern Europe           | Italian
 Switzerland                   | Western Europe            | Italian
 Holy See (Vatican City State) | Southern Europe           | Italian
 United States                 | North America             | Italian
(15 rows)


-- Clue #4: We're booking the first flight out – maybe we've actually got a chance to catch her this time.
 -- There are only two cities she could be flying to in the country. One is named the same as the country – that
 -- would be too obvious. We're following our gut on this one; find out what other city in that country she might
 --  be flying to.

SELECT city.name, country.name, countrylanguage.language, country.continent, country.region FROM city JOIN country ON city.countrycode = country.code JOIN countrylanguage ON city.countrycode = countrylanguage.countrycode WHERE city.name = country.name AND countrylanguage.language = 'Italian' ORDER BY countrylanguage.language;     name    |    name    | continent |     region      
city name | country name | language | continent |  region      
------------+------------+----------+-----------+-----------------
 San Marino | San Marino | Italian  | Europe    | Southern Europe

-- My Answer
 carmen=# SELECT * FROM country WHERE name = 'San Marino';
carmen=# SELECT * FROM city WHERE countrycode = 'SMR';
  id  |    name    | countrycode |     district      | population 
------+------------+-------------+-------------------+------------
 3170 | Serravalle | SMR         | Serravalle/Dogano |       4802
 3171 | San Marino | SMR         | San Marino        |       2294
(2 rows)


-- Clue #5: Oh no, she pulled a switch – there are two cities with very similar names, but in totally different
-- parts of the globe! She's headed to South America as we speak; go find a city whose name is like the one we were
-- headed to, but doesn't end the same. Find out the city, and do another search for what country it's in. Hurry!
SELECT city.name, country.name, country.continent, country.region FROM city JOIN country ON city.countrycode = country.code WHERE country.region = 'South America' AND city.name LIKE '%San%' ORDER BY country.region;
        city name       |  country name    |   continent   |    region     
--------------------------------+-----------+---------------+---------------
 San Miguel de Tucum�n        | Argentina | South America | South America
 General San Mart�n           | Argentina | South America | South America
 Santa F�                     | Argentina | South America | South America
 San Isidro                     | Argentina | South America | South America
 San Miguel                     | Argentina | South America | South America
 Santiago del Estero            | Argentina | South America | South America
 San Salvador de Jujuy          | Argentina | South America | South America
 San Fernando                   | Argentina | South America | South America
 San Fernando del Valle de Cata | Argentina | South America | South America
 San Nicol�s de los Arroyos   | Argentina | South America | South America

 -- My Answer
 SELECT city.name, country.name, country.continent, country.region FROM city JOIN country ON city.countrycode = country.code WHERE country.region = 'South America' AND city.name LIKE '%San%';

              name              |   name    |   continent   |    region     
--------------------------------+-----------+---------------+---------------
 San Miguel de Tucumï¿½n        | Argentina | South America | South America
 General San Martï¿½n           | Argentina | South America | South America
 Santa Fï¿½                     | Argentina | South America | South America
 San Isidro                     | Argentina | South America | South America
 San Miguel                     | Argentina | South America | South America
 Santiago del Estero            | Argentina | South America | South America
 San Salvador de Jujuy          | Argentina | South America | South America
 San Fernando                   | Argentina | South America | South America
 San Fernando del Valle de Cata | Argentina | South America | South America
 San Nicolï¿½s de los Arroyos   | Argentina | South America | South America
 San Juan                       | Argentina | South America | South America
 San Luis                       | Argentina | South America | South America
 San Rafael                     | Argentina | South America | South America
 Santa Cruz de la Sierra        | Bolivia   | South America | South America
 Santo Andrï¿½                  | Brazil    | South America | South America
 Feira de Santana               | Brazil    | South America | South America
 Santos                         | Brazil    | South America | South America
 Santarï¿½m                     | Brazil    | South America | South America
 Santa Maria                    | Brazil    | South America | South America
 Santa Bï¿½rbara dï¿½Oeste      | Brazil    | South America | South America
 Santa Luzia                    | Brazil    | South America | South America
 Cabo de Santo Agostinho        | Brazil    | South America | South America
 Vitï¿½ria de Santo Antï¿½o     | Brazil    | South America | South America
 Santa Rita                     | Brazil    | South America | South America
 Santa Cruz do Sul              | Brazil    | South America | South America
 Santana do Livramento          | Brazil    | South America | South America
 Santiago de Chile              | Chile     | South America | South America
 San Bernardo                   | Chile     | South America | South America
 San Pedro de la Paz            | Chile     | South America | South America
 Santo Domingo de los Colorados | Ecuador   | South America | South America
 Santafï¿½ de Bogotï¿½          | Colombia  | South America | South America
 Santa Marta                    | Colombia  | South America | South America
 San Lorenzo                    | Paraguay  | South America | South America
 San Cristï¿½bal                | Venezuela | South America | South America
 Santa Ana de Coro              | Venezuela | South America | South America
 San Fernando de Apure          | Venezuela | South America | South America
 San Felipe                     | Venezuela | South America | South America
(37 rows)


-- Clue #6: We're close! Our South American agent says she just got a taxi at the airport, and is headed towards
 -- the capital! Look up the country's capital, and get there pronto! Send us the name of where you're headed and we'll
 -- follow right behind you!

SELECT country.name, country.capital, country.localname, city.district FROM country JOIN city ON country.code = city.countrycode WHERE country.name = 'Argentina' AND city.district = 'Buenos Aires';
==> Buenos Aires

--My Answer
Buenos Aires

-- Clue #7: She knows we're on to her – her taxi dropped her off at the international airport, and she beat us to
 -- the boarding gates. We have one chance to catch her, we just have to know where she's heading and beat her to the
 -- landing dock HINT:Look at number 8.
SELECT country.name, country.continent, country.region, city.name, city.population, city.district FROM country JOIN city ON country.code = city.countrycode WHERE city.population IN (91001, 85001, 91000, 85000);
        name        | continent |     region     |    name     | population | district 
--------------------+-----------+----------------+-------------+------------+----------
 Saudi Arabia       | Asia      | Middle East    | Najran      |      91000 | Najran
 Russian Federation | Europe    | Eastern Europe | Krasnogorsk |      91000 | Moskova

-- Clue #8: Lucky for us, she's getting cocky. She left us a note, and I'm sure she thinks she's very clever, but
-- if we can crack it, we can finally put her where she belongs – behind bars.

--My Answer
Key words are somewhere warm, with a population of ninety-one thousand and now eighty five thousand.
The eighty five thousand is where i am thrown off though.


-- Our playdate of late has been unusually fun –
-- As an agent, I'll say, you've been a joy to outrun.
-- And while the food here is great, and the people – so nice!
-- I need a little more sunshine with my slice of life.
-- So I'm off to add one to the population I find
-- In a city of ninety-one thousand and now, eighty five.


-- We're counting on you, gumshoe. Find out where she's headed, send us the info, and we'll be sure to meet her at the gates with bells on.



-- She's in the Middle East, in the city of Najran in Saudi Arabia. It won't be Russia because its cold in Russia, but 'a little more sunshine with my slice of life' sounds like Saudi Arabia! Kinda hope we don't catch her though.
