require 'pry'
require 'pg'
require 'sinatra'
require 'sinatra/reloader'

require_relative 'DB/db_config'
require_relative 'models/airport'

#FlightXML API
require_relative 'FlightXML2RESTDriver.rb'
require_relative 'FlightXML2REST.rb'
#Flight Aware api key
username = 'ruixu0530'
apiKey = 'ace744cee1f5f33d07f18240d742653c0f670747'

get '/' do
  @airports = Airport.where("country = 'Australia'")
  erb :index
end

get '/arpt_detail/:id' do
	@theAirport = Airport.find(params[:id])
	# binding.pry
	erb :airport_specs
end

get '/orgin_detail/:icao' do
	@theAirport = Airport.find_by(icao: params[:icao])
	# binding.pry
	erb :airport_specs
end


get '/enroute/:icao' do
  flight_aware = FlightXML2REST.new(username, apiKey)
  @incoming = flight_aware.Enroute(EnrouteRequest.new(params[:icao],'airline', 15, 0 ))
  erb :inbound_traffic
end
