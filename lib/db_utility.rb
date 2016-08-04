require 'pry'
require 'active_record'
require_relative '../DB/db_config'
require_relative '../models/airport'
require_relative '../models/flight'



def destin_filter originSch_result, destin_city
  route_sch = [];
  originSch_result.scheduledResult.scheduled.each do |flight|
    if flight.destination == destin_city
      route_sch << flight
    end
  end
  route_sch
end



def insert_flight flt_result
  time_filter = Flight.maximum(:actualdeparturetime)
  flt_result.each do |flight| #insert and populate flight database
    record = Flight.new

    if (time_filter&&flight.actualdeparturetime > time_filter)|| time_filter == nil
      # flight.attributes.each do |attr_name, attr_value|
      #
      # end
      record.actualdeparturetime = flight.actualdeparturetime
      record.aircrafttype = flight.aircrafttype
      record.destination = flight.destination
      record.destinationcity = flight.destinationCity
      record.destinationname = flight.destinationName
      record.diverted = flight.diverted
      record.estimatedarrivaltime = flight.estimatedarrivaltime
      record.filed_airspeed_kts = flight.filed_airspeed_kts
      record.filed_airspeed_mach = flight.filed_airspeed_mach
      record.filed_altitude = flight.filed_altitude
      record.filed_departuretime = flight.filed_departuretime
      record.filed_ete = flight.filed_ete
      record.filed_time = flight.filed_time
      record.ident = flight.ident
      record.origin = flight.origin
      record.origincity = flight.originCity
      record.originname = flight.originName
      record.route = flight.route
      record.save
      return true
    else
      return false
    end
  end
end
