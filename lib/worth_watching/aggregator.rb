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
      uri = "#{RT_API_BASE_URL}/lists/movies/in_theaters.json?page_limit=15&page=1&country=uk&apikey=#{rt_api_key}"
      movie_list = HTTParty.get(uri)
      movie_list = movie_list["movies"]
      in_theaters = []

      movie_list.each do |movie|
        if enough_info?(movie)
          movie = movie_info(movie['id'])
          in_theaters << movie
        end
      end
      Aggregator.clean_up(in_theaters)
      in_theaters.each { |movie| puts movie["title"]}
      #puts "Original list: #{movie_list.size} || Movies with release dates & rating #{in_theaters.size}"

      return in_theaters
    end

    private

    # Checks that a given movie has enough information available via API. For example,
    # if the Rotten Tomatoes API does not include the IMDb ID for a particular movie
    # then we cannot retrieve its IMDb rating.
    # @param [Hash] the hash representation of the movie to check
    # @return [Boolean] whether the movie has a theather release date and IMDb ID
    def enough_info?(movie)

      has_release_date = false
      has_imdb_id = false

      # Check that if it has a release date that the theather release date is present
      if movie.has_key?("release_dates")
        if movie["release_dates"].has_key?("theater")
          has_release_date = !movie["release_dates"]["theater"].empty?
        end
      end

      # Check IMDb ID is present
      if movie.has_key?("alternate_ids")
        if movie["alternate_ids"].has_key?("imdb")
          has_imdb_id = !movie["alternate_ids"]["imdb"].empty?
        end
      end

      return has_release_date && has_imdb_id 
    end

    # Removes movies from an array that do no have the required rating information
    # @param movie_list [Array] the list to clean up
    # @return [Array] the pruned list of movies
    def self.clean_up(movie_list)
      movie_list.delete_if do |movie| 
        movie.metacritic_rating == "No Rating"
     end
    end

  end
end