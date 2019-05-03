     
require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require 'httparty'
require 'uri'
require 'active_record'
require_relative 'models/movie'

options = {
  adapter:'postgresql',
  #  canbe any SQL  that activerecord understands
  database:'movie_cache'
}

ActiveRecord::Base.establish_connection(options)
after do 
    ActiveRecord::Base.connection.close

end
get '/' do

  erb :index
  
end

get '/movies' do
  search_result = HTTParty.get("http://www.omdbapi.com/?apikey=2f6435d9&s=#{params['title']}")
  response = search_result["Response"] 
  @lists = search_result["Search"] #array contain hashes  
  @title = params['title'] # input value
  @file = File.new('search_history.txt','a+')
  @file.puts @title
  @file.close
  # the @ enable the variable to use in the erb file

  if response == "True"
    if @lists.length > 1
      erb :lists 
    else
      # binding.pry 
    redirect URI::encode("/movies/#{@lists[0]["imdbID"]}")
    end
  else
    erb :not_found 
  end
end
get '/movies/:id' do 
  @id=params[:id] # get the imdbID

  if Movie.where(imdbid:@id).length != 0
    # get the information from the movie_cache database instead of OMDB
    # binding.pry
    db_id = Movie.where(imdbid:@id)[0]["id"]
    movie = Movie.find(db_id) # return array 
    @year = movie.year_publish
    @poster = movie.poster
    @title = movie.title
    @plot = movie.plot
    erb :about
  else
    # binding.pry
    result = HTTParty.get("http://www.omdbapi.com/?apikey=2f6435d9&i=#{@id}")
    @year = result["Year"]
    @poster = result["Poster"]
    @title = result["Title"]
    @plot = result["Plot"]
    # store the information in the movie_cache database
    new_movie = Movie.new
    new_movie.poster = @poster
    new_movie.title = @title
    new_movie.plot = @plot
    new_movie.imdbid = @id
    new_movie.year_publish = @year
    new_movie.save
    erb :about
  end
end

get '/history' do
  @file = File.new('search_history.txt','r')
  erb :history
  
end


post '/history/clear' do
  File.truncate('search_history.txt', 0)
  redirect '/history'
  
  
end

#URI.escape("  apple")    "%20%20apple"

