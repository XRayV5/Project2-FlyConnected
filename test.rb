require_relative 'FlightXML2RESTDriver.rb'
require_relative 'FlightXML2REST.rb'
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
result = test.Departed(DepartedRequest.new("YMML", 'airline', 15, 0))
p result.departedResult.departures
binding.pry
