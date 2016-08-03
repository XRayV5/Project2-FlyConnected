require 'active_record'

options = {
	  adapter: 'postgresql',
  database: 'civilaviation',
}

ActiveRecord::Base.establish_connection(options)