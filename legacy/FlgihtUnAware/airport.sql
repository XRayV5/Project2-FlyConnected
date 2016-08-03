create table Airports(
  id SERIAL4 primary key,
  f_id integer,
  name varchar(200),
  city varchar(100),
  country varchar(100),
  ITTA varchar(10),
  ICAO varchar(10),
  latitude decimal,
  longitude decimal,
  Altitude decimal,
  Timezone decimal,
  DST varchar(10),
  tz varchar(100)
);
26,"Kugaaruk","Pelly Bay","Canada","YBB","CYBB",68.534444,-89.808056,56,-7,"A","America/Edmonton"

COPY Airports(f_id, name, city, country, ITTA, ICAO, latitude, longitude, Altitude, Timezone, DST, tz) FROM '/home/adminone/GA_work/wdi-fundamentals/WDI8_MELB_homework/Rui_Xu/w4_d2_FlightInfo/FlgihtUnAware/data/airports.dat' DELIMITER ',' CSV;
