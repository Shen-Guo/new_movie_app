require 'pg'
require 'active_record'

options = {
  adapter: 'postgresql',
  database: 'movie_cache'
}

ActiveRecord::Base.establish_connection(options)