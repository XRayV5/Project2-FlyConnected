require_relative 'FlightXML2RESTDriver.rb'
require_relative 'FlightXML2REST.rb'
require './lib/db_utility.rb'
require_relative 'models/flightlog'
require_relative 'models/flightlog'
require_relative 'models/tag'
require_relative 'models/airport'
require_relative 'models/user'

require 'pry'

username = 'ruixu0530'
#apiKey = ENV[]

# # This provides the basis for all future calls to the API
# test = FlightXML2REST.new(username, apiKey)
#ace744cee1f5f33d07f18240d742653c0f670747
# This provides the basis for all future calls to the API
test = FlightXML2REST.new(username, ENV['FlightAPI'])
# Enroute
print "Aircraft en route to KSMO:\n"
# result = test.Scheduled(ScheduledRequest.new("YMML",'airline', 15, 0 ))
# p result.scheduledResult
#result = test.AirportInfo(AirportInfoRequest.new('YMML'))
# #p result.airportInfoResult
# result = test.FlightInfo(FlightInfoRequest.new( 15,'CCA178'))
# p result.flightInfoResult
# result = test.Arrived(ArrivedRequest.new("YMML", 'airline', 15, 0))
# p result.arrivedResult

# result = test.Departed(DepartedRequest.new("YMML", 'airline', 15, 0))
# p result.departedResult.departures
# fetch_to_log result.departedResult.departures

result = test.FlightInfo(FlightInfoRequest.new( 15,'CCA177'))
p result.flightInfoResult.flights
fetch_to_log result.flightInfoResult.flights

# result = test.Scheduled(ScheduledRequest.new("YMML",'airline', 15, 0 ))
# p result.scheduledResult.scheduled
# fetch_to_log result.scheduledResult.scheduled

# result = test.Enroute(EnrouteRequest.new("YSSY",'airline',15,0))
# p result.enrouteResult.enroute
# fetch_to_log result.enrouteResult.enroute
# binding.pry

# t1 = Tag.new
# t2 = Tag.new
# t3 = Tag.new
# t4 = Tag.new
#
# t1.user_id = 1
# t1.airport_id = 11
# t1.save
#
#
#
# t2.user_id = 1
# t2.airport_id = 20
# t2.save
#
# t3.user_id = 1
# t3.airport_id = 13
# t3.save

# t4.user_id = 1
# t4.airport_id = 11
# t4.save

binding.pry
