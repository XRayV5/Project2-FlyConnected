create table Airports(
  id SERIAL4 primary key,
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

create table users(
  id SERIAL4 primary key,
  email varchar(100) not null,
  password_digest varchar(500) not null,
  nickname varchar(100),
);






create table Flights(
  id SERIAL4 primary key,
  actualdeparturetime integer,
  aircrafttype varchar(50),
  destination varchar(50),
  destinationCity varchar(100),
  destinationName varchar(100),
  diverted varchar(50),
  estimatedarrivaltime integer,
  filed_airspeed_kts integer,
  filed_airspeed_mach decimal,
  filed_altitude integer,
  filed_departuretime integer,
  filed_ete varchar(50),
  filed_time integer,
  ident varchar(50),
  origin varchar(50),
  originCity varchar(100),
  originName varchar(100),
  route varchar(2000)
);


-- 26,"Kugaaruk","Pelly Bay","Canada","YBB","CYBB",68.534444,-89.808056,56,-7,"A","America/Edmonton"
--
-- COPY Airports(f_id, name, city, country, ITTA, ICAO, latitude, longitude, Altitude, Timezone, DST, tz) FROM '/home/adminone/GA_work/wdi-fundamentals/WDI8_MELB_homework/Rui_Xu/w4_d2_FlightInfo/FlgihtUnAware/data/airports.dat' DELIMITER ',' CSV;




-- Column   |          Type          |                       Modifiers
-- -----------+------------------------+-------------------------------------------------------
-- id        | integer                | not null default nextval('airports_id_seq'::regclass)
-- name      | character varying(200) |
-- city      | character varying(100) |
-- country   | character varying(100) |
-- itta      | character varying(10)  |
-- icao      | character varying(10)  |
-- latitude  | numeric                |
-- longitude | numeric                |
-- altitude  | numeric                |
-- timezone  | numeric                |
-- dst       | character varying(10)  |
-- tz        | character varying(100) |
