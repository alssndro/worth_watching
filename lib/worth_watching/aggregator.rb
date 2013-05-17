require 'httparty'

module WorthWatching
  class Aggregator

    attr_accessor :rt_api_key, :tmdb_api_key

    RT_API_BASE_URL = 'http://api.rottentomatoes.com/api/public/v1.0'
    TMDB_BASE_URL = 'http://api.themoviedb.org/3'
  
    # Initialize a new Aggregator object to retrieve movie info
    def initialize
      config = YAML.load_file('config/config.yml')
      @rt_api_key = config['rt_api_key']
      @tmdb_api_key = config['tmdb_api_key']
    end

    # Retrieve the details of a specific movie using its IMDB ID
    # @param rt_id [String] the Rotten Tomatoes ID of the movie
    # @return [Movie] a Movie object representing the movie
    def movie_info(rt_id)
      uri = "#{RT_API_BASE_URL}/movies/#{rt_id}.json?apikey=#{rt_api_key}"
      movie_hash = HTTParty.get(uri)
      Movie.new(movie_hash, tmdb_api_key)
    end

    # Retrieve a list of movies that are currently in cinemas
    # @return [Array] an Array of Movie objects
    def in_cinemas
      uri = "#{RT_API_BASE_URL}/lists/movies/in_theaters.json?page_limit=10&page=1&country=uk&apikey=#{rt_api_key}"
      movie_list = HTTParty.get(uri)
      movie_list = movie_list["movies"]
      in_theaters = []

      movie_list.each do |movie|
        if movie['release_dates'].empty? != true && movie['release_dates']['theater'].empty? != true
          movie = movie_info(movie['id'])
          in_theaters << movie
        end
        puts "Original list: #{movie_list.size} || Movies with release dates #{in_theaters.size}"
      end
      in_theaters.each { |movie| puts movie.title}
      return in_theaters
    end
  end
end