require 'pry'
require 'sinatra'
require 'sinatra/reloader'

require 'active_record'
require_relative 'DB/db_config'

# models
require_relative 'models/airport'
require_relative 'models/flight'
require_relative 'models/user'

require_relative 'lib/db_utility'

#FlightXML API
require_relative 'API/FlightXML2RESTDriver.rb'
require_relative 'API/FlightXML2REST.rb'
#Flight Aware api key


helpers do
  #flgihtaware API instance
  def flt_awr
      username = 'ruixu0530'
      FlightXML2REST.new(username, ENV['FlightAPI'])
  end

  # def empty_filter param_hash #not tested yet
  #   param_hash.each do |key, value|
  #     if param.strip == nil
  #       param_hash.delete_if{|key, value| value.nil?}
  #     end
  #   end
  # end

  #Session check
    def logged_in?
      if User.find_by(id: session[:user_id]) == nil
        return false
      else
        return true
      end
    end
  #user profile accessor
    def current_user
      User.find(session[:user_id])
    end

end

enable :sessions

post '/session/login' do
  @login_flag = true
  theUser = User.find_by(email: params[:email])
  if theUser&&theUser.authenticate(params[:password])
    session[:user_id] = theUser.id
    redirect to '/'
  else
    @login_flag = false
    erb :index
  end
end





post '/session/signup' do
    new_user = User.new()
    new_user.email = params[:email]
    new_user.password = params[:password]
    new_user.nickname = params[:nickname]
    new_user.save
    @user = User.find_by(email: params[:email])
    if @user != nil
      session[:user_id] = @user.id
      erb :index
    else
      erb :fail
    end
end

get '/session/logout' do
  session.delete(:user_id)
  redirect to '/'
end


get '/' do
  #@airports = Airport.where("country = 'Australia'")
  erb :index
end

get '/arpt_filter' do
    @flag = params['arpt_by']
  if @flag == 'city'
    @arpt_result = Airport.where("city LIKE ?", "%#{params['arpt_query']}%")
  elsif @flag == 'icao' && params['arpt_query'].length < 4
    @arpt_result = Airport.where("icao LIKE ?", "#{params['arpt_query']}%")
  else
    @arpt_result = Airport.where("#{params['arpt_by']} = '#{params['arpt_query']}'")
  end
    erb :airports_view
end

get '/flt_filter' do
    callsign = params['flt_code']
    airline = params['flt_Airline']
    des_city = params['flt_destin']
    ori_city = params['flt_origin']
    if callsign != ""
      @flt_result = flt_awr.FlightInfo(FlightInfoRequest.new(15,callsign))
      records = @flt_result.flightInfoResult.flights
      # binding.pry
      insert_flight(records)
          erb :flights_view
    elsif des_city != "" && ori_city != ""
      @destinSch_result = flt_awr.Scheduled(ScheduledRequest.new(params[:flt_destin],'airline', 15, 0 ))
      @originSch_result = flt_awr.Scheduled(ScheduledRequest.new(params[:flt_origin], 'airline', 15, 0 ))
      erb :route_view
    end

end

get '/arpt_detail/:id' do
  if logged_in?
  	@theAirport = Airport.find(params[:id])
  	# binding.pry
  	erb :airport_specs
  else
    erb :fail
  end
end

get '/orgin_detail/:icao' do
	@theAirport = Airport.find_by(icao: params[:icao])
	# binding.pry
	erb :airport_specs
end

get '/enroute/:icao' do
  @incoming = flt_awr.Enroute(EnrouteRequest.new(params[:icao],'airline', 15, 0 ))
  erb :inbound_traffic
end
