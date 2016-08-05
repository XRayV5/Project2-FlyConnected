require 'pry'
require 'sinatra'
require 'sinatra/reloader'

require 'active_record'
require_relative 'DB/db_config'

# models
require_relative 'models/airport'
require_relative 'models/flight'
require_relative 'models/user'
require_relative 'models/flightlog'
require_relative 'models/Route'
require_relative 'models/Tag'


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

  def api_handler api_flag, query
      if api_flag == 'FlightInfo'
        result = flt_awr.FlightInfo(FlightInfoRequest.new(15,query))
        result = result.flightInfoResult.flights
      elsif api_flag == 'Enroute'
        result = flt_awr.Enroute(EnrouteRequest.new(query,'airline', 15, 0 ))
        result = result.enrouteResult.enroute
      elsif api_flag == 'Scheduled'
        result = flt_awr.Scheduled(ScheduledRequest.new(query, 'airline', 15, 0 ))
        result = result.scheduledResult.scheduled
      elsif api_flag == 'Departed'
        result = flt_awr.Departed(DepartedRequest.new(query, 'airline', 15, 0))
        result = result.departedResult.departures
      elsif api_flag == 'Arrived'
        result = flt_awr.Arrived(ArrivedRequest.new(query, 'airline', 15, 0))
        result = result.arrivedResult.arrivals
      else
        return false
      end
      result
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

    def arpttags
      User.find(current_user.id).tags.collect{|a| a.airport}.count if logged_in?
    end
    def routetags
      Route.where("user_id = #{current_user.id}").count if logged_in?
    end
    def flttags
      Flight.where("user_id = #{current_user.id}").count if logged_in?
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
  erb :index
end



get '/arpt_filter' do
    @flag = params['arpt_by']
      if @flag == 'city'
        @arpt_result = Airport.where("city LIKE ?", "%#{params['arpt_query']}%")
      elsif @flag == 'icao' && params['arpt_query'].length < 4
        @arpt_result = Airport.where("icao LIKE ?", "#{params['arpt_query']}%")
      elsif @flag == 'itta' && params['arpt_query'].length < 4
        @arpt_result = Airport.where("itta LIKE ?", "#{params['arpt_query']}%")
      else
        @arpt_result = Airport.where("#{params['arpt_by']} = '#{params['arpt_query']}'")
      end

    erb :airports_view
end

get '/flt_filter' do
    callsign = params['flt_code']
    airline = params['flt_Airline']
    if callsign != ""
      begin
      @flt_result = flt_awr.FlightInfo(FlightInfoRequest.new(15,callsign))
      records = @flt_result.flightInfoResult.flights
      # binding.pry
      fetch_to_log records
      rescue
      end
      erb :flights_view
    end

end

get '/tag_flight/:ident' do
  if logged_in?
    theFlight = Flight.new
    theFlight.ident = params[:ident]
    theFlight.origin = params[:origin]
    theFlight.destination = params[:destin]
    theFlight.user_id = current_user.id
    theFlight.save
    @myFlights = Flight.where("user_id = #{current_user.id}")

    erb :flight_tags
  else
    erb :fail
  end
end

get '/tag_flight' do
  if logged_in?
    @myFlights = Flight.where("user_id = #{current_user.id}")
    erb :flight_tags
  else
    erb :fail
  end
end

get '/flight_untag/:id' do
  untag_flt = Flight.find_by(id: params[:id])
  Flight.delete(untag_flt)
  redirect to '/tag_flight'
end

get '/flt_filter/route' do
    des_city = params['flt_destin']
    ori_city = params['flt_origin']
    query_type = params['flt_by']
    saved = params[:saved]
    @is_route = false;

  begin
    if query_type != 'airport'
        if ori_city != ""&& des_city == ""
          @route_result = flt_awr.Scheduled(ScheduledRequest.new(params[:flt_origin], 'airline', 15, 0 ))
        elsif ori_city != ""&& des_city != ""
          route_result = flt_awr.Scheduled(ScheduledRequest.new(params[:flt_origin], 'airline', 15, 0 ))
          # destination filter method(@originSch_result)
          @route_result = destin_filter(route_result, des_city)
          @is_route = true;
        end

        if saved == "on"&&logged_in?
          theRoute = Route.new
          theRoute.origin_icao = ori_city
          theRoute.origin = Airport.find_by(icao: ori_city).name
          theRoute.destination_icao = des_city
          theRoute.destination = Airport.find_by(icao: des_city).name
          theRoute.user_id = current_user.id
          theRoute.save
        end
    else
        #search by name here
        if ori_city != ""&& des_city == ""
          ori_result = Airport.where("name LIKE ?", "%#{ori_city}%").first.icao
        elsif ori_city != ""&& des_city != ""
          ori_result = Airport.where("name LIKE ?", "%#{ori_city}%").first.icao
          des_result = Airport.where("name LIKE ?", "%#{des_city}%").first.icao

          route_result = flt_awr.Scheduled(ScheduledRequest.new(ori_result, 'airline', 15, 0 ))
          @route_result = destin_filter(route_result, des_result)
          @is_route = true;

          if saved == "on"&&logged_in?
            theRoute = Route.new
            theRoute.origin_icao = ori_result
            theRoute.origin = Airport.find_by(icao: ori_result).name
            theRoute.destination_icao = des_result
            theRoute.destination = Airport.find_by(icao: des_result).name
            theRoute.user_id = current_user.id
            theRoute.save
          end

        end
    end
    erb :route_view
  rescue NoMethodError, SyntaxError
    erb :fail
  end
end

get "/tagged_route" do
  if logged_in?
    @myRoutes = Route.where("user_id = #{current_user.id}")
    erb :route_tagged
  else
    erb :fail
  end
end

get '/route_untag/:id' do
  untag = Route.where("id = #{params[:id]}")
  Route.delete(untag)
  redirect to '/tagged_route'
end

get '/arpt_detail/:icao' do
  if logged_in?
  	@theAirport = Airport.find_by(icao: params[:icao])
  	# binding.pry
    @Arrived = api_handler('Arrived', params[:icao])
    @Departed = api_handler('Departed', params[:icao])
    fetch_to_log @Departed
    @Scheduled = api_handler('Scheduled', params[:icao])
    fetch_to_log @Scheduled
    @Enroute = api_handler('Enroute', params[:icao])
    fetch_to_log @Enroute
    #binding.pry
    erb :airport_specs
  else
    erb :fail
  end
end


#add airport tags
get '/arpt_watchlist/:id' do
  if logged_in?
    theTag = Tag.new
    theTag.user_id = current_user.id
    theTag.airport_id = params[:id]
    theTag.save
    @taggedAirport = User.find(current_user.id).tags.collect{|a| a.airport}
    erb :airportTags
  else
    erb :fail
  end
end

get '/arpt_watchlist' do
  if logged_in?
    @taggedAirport = User.find(current_user.id).tags.collect{|a| a.airport}
    erb :airportTags
  else
    erb :fail
  end
end

get '/arpt_untag/:id' do
  untag = Tag.where("user_id=#{current_user.id} and airport_id = #{params[:id]}")
  Tag.delete(untag)
  redirect to '/arpt_watchlist'
end


get '/fail' do
  erb :fail
end
# Need session check
# get '/orgin_detail/:icao' do
#   if logged_in?
#   	@theAirport = Airport.find_by(icao: params[:icao])
# 	erb :airport_specs
#   else
#     erb :fail
#   end
# end

# get '/enroute/:icao' do
#   @incoming = flt_awr.Enroute(EnrouteRequest.new(params[:icao],'airline', 15, 0 ))
#   erb :inbound_traffic
# end
