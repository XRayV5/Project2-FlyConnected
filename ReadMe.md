#Flight Ray-Dar
- select and show airport info of (v1.0 Australia)
- show flight info of all enroute flights to an airport
- flight/airport data visualization with google map API

http://www.aircharterguide.com/AirportSearch.aspx?Region=Asia+%5bfs%5d+Pacific&Country=AU


https://en.wikipedia.org/wiki/List_of_airports_by_ICAO_code:_Y

- all airports http://openflights.org/data.html
https://raw.githubusercontent.com/jpatokal/openflights/master/data/airports.dat

Airport ID	Unique OpenFlights identifier for this airport.
Name	Name of airport. May or may not contain the City name.
City	Main city served by airport. May be spelled differently from Name.
Country	Country or territory where airport is located.
IATA/FAA	3-letter FAA code, for airports located in Country "United States of America".
3-letter IATA code, for all other airports.
Blank if not assigned.
ICAO	4-letter ICAO code.
Blank if not assigned.
Latitude	Decimal degrees, usually to six significant digits. Negative is South, positive is North.
Longitude	Decimal degrees, usually to six significant digits. Negative is West, positive is East.
Altitude	In feet.
Timezone	Hours offset from UTC. Fractional hours are expressed as decimals, eg. India is 5.5.
DST	Daylight savings time. One of E (Europe), A (US/Canada), S (South America), O (Australia), Z (New Zealand), N (None) or U (Unknown). See also: Help: Time
Tz database time zone	Timezone in "tz" (Olson) format, eg. "America/Los_Angeles".



Sprint 1
1. -done get all Aus airport data and push it to the DB
2. -done implement the view for each airport including  a google API map centred        and marked at the airport; details of the airport.
3. - done For each airport, list the all enroute flgiht(inbound) to this airport
  and display the info of this flight: aircrafttype, origin, Departuretime, arrival time

Sprint 2
4. Search function for airports: by country, icao, city, states
5. update the airport database table along with each search
6. asycn data presentation for search result both airports and enroute flights
7. basic form data validation front-end and application layer
