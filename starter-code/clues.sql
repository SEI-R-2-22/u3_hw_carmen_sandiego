-- Clue #1: We recently got word that someone fitting Carmen Sandiego's description has been
-- traveling through Southern Europe. She's most likely traveling someplace where she won't be noticed,
-- so find the least populated country in Southern Europe, and we'll start looking for her there.


--SELECT country.name, population FROM country WHERE continent = 'Europe' ORDER BY population ASC LIMIT 10;

--Answer: Holy See (Vatican City State)


-------------------------------*


-- Clue #2: Now that we're here, we have insight that Carmen was seen attending language classes in
-- this country's officially recognized language. Check our databases and find out what language is
-- spoken in this country, so we can call in a translator to work with you.


--SELECT language FROM countryLanguage JOIN country ON countryLanguage.countrycode = country.code WHERE country.name = 'Holy See (Vatican City State)';

--Answer: Italian


-------------------------------*


-- Clue #3: We have new news on the classes Carmen attended – our gumshoes tell us she's moved on
-- to a different country, a country where people speak only the language she was learning. Find out which
--  nearby country speaks nothing but that language.

--(I split the code in two at first since I wanted to see %'s, I didn't quite believe that a country spoke nothing but one language)

--SELECT countryLanguage.countrycode, countryLanguage.percentage FROM countryLanguage JOIN country ON countryLanguage.countrycode = country.code WHERE country.continent = 'Europe' AND countryLanguage.language = 'Italian' ORDER BY countryLanguage.percentage DESC;

--SELECT country.name FROM country WHERE country.code = 'SMR';


--(Now that I know the % is actually 100, I can probably just do it in one, like below)

--carmen=# SELECT country.name FROM country JOIN countryLanguage ON country.code = countryLanguage.countrycode WHERE country.continent = 'Europe' AND countryLanguage.language = 'Italian' AND countryLanguage.percentage = 100;

--Answer: San Marino

-------------------------------*

-- Clue #4: We're booking the first flight out – maybe we've actually got a chance to catch her this time.
 -- There are only two cities she could be flying to in the country. One is named the same as the country – that
 -- would be too obvious. We're following our gut on this one; find out what other city in that country she might
 --  be flying to.


--SELECT city.name FROM city JOIN country ON city.countrycode = country.code WHERE city.countrycode = 'SMR';

--Answer: Serravalle


-------------------------------*


-- Clue #5: Oh no, she pulled a switch – there are two cities with very similar names, but in totally different
-- parts of the globe! She's headed to South America as we speak; go find a city whose name is like the one we were
-- headed to, but doesn't end the same. Find out the city, and do another search for what country it's in. Hurry!


--SELECT city.name FROM city JOIN country ON city.countrycode = country.code WHERE country.continent = 'South America' AND city.name LIKE 'Serr%';

--SELECT country.name FROM country JOIN city ON country.code = city.countrycode WHERE country.continent = 'South America' AND city.name = 'Serra';

--Answer: Serra, Brazil


-------------------------------*


-- Clue #6: We're close! Our South American agent says she just got a taxi at the airport, and is headed towards
 -- the capital! Look up the country's capital, and get there pronto! Send us the name of where you're headed and we'll
 -- follow right behind you!


 --SELECT country.capital FROM country WHERE country.name = 'Brazil';

 --Answer: 211

 --(I'm not sure if this is intended to be a number, given that the context of the clue implies that it is a location. It's the only reference to 'capital' I can find in Country (City has no column of that name))


 -------------------------------*


-- Clue #7: She knows we're on to her – her taxi dropped her off at the international airport, and she beat us to
 -- the boarding gates. We have one chance to catch her, we just have to know where she's heading and beat her to the
 -- landing dock HINT:Look at number 8.

-- Clue #8: Lucky for us, she's getting cocky. She left us a note, and I'm sure she thinks she's very clever, but
-- if we can crack it, we can finally put her where she belongs – behind bars.

-- Our playdate of late has been unusually fun –
-- As an agent, I'll say, you've been a joy to outrun.
-- And while the food here is great, and the people – so nice!
-- I need a little more sunshine with my slice of life.
-- So I'm off to add one to the population I find
-- In a city of ninety-one thousand and now, eighty five.



-- We're counting on you, gumshoe. Find out where she's headed, send us the info, and we'll be sure to meet her at the gates with bells on.



--SELECT city.name, city.population, city.countrycode FROM city WHERE city.population > 91083 ORDER BY city.population ASC LIMIT 10;

-- She's in __Santa Monica, USA__!
