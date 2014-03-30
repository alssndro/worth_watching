require 'nokogiri'
require 'open-uri'
require 'typhoeus'
require 'json'

module WorthWatching
  class Aggregator

    attr_accessor :rt_api_key, :tmdb_api_key
    attr_reader :movie

    RT_API_BASE_URL = 'http://api.rottentomatoes.com/api/public/v1.0'
    TMDB_API_BASE_URL = 'http://api.themoviedb.org/3'

    # Initialize a new Aggregator object to retrieve movie info
    def initialize(rt_api_key, tmdb_api_key)
      @rt_api_key = rt_api_key
      @tmdb_api_key = tmdb_api_key
    end

    # Retrieve the details of a specific movie using its IMDB ID
    # @param rt_id [String] the Rotten Tomatoes ID of the movie
    # @return [Movie] a Movie object representing the movie
    def aggregate_movie(rt_id)
      uri = "#{RT_API_BASE_URL}/movies/#{rt_id}.json?apikey=#{rt_api_key}"
      movie_hash = JSON.parse(Typhoeus.get(uri).body)

      @movie = Movie.new(movie_hash)
      aggregate
    end

    # Retrieve a list of movies that are currently in cinemas
    # @param result_limit [Integer] the maximum number of results to return
    # @return [Array] an Array of Movie objects
    def in_cinemas(result_limit, type)

      case type
        when :cinema
          uri = "#{RT_API_BASE_URL}/lists/movies/in_theaters.json?page_limit=#{result_limit}"\
                "&page=1&country=uk&apikey=#{rt_api_key}"
        when :dvd
          uri = "#{RT_API_BASE_URL}/lists/dvds/top_rentals.json?page_limit=#{result_limit}"\
                "&page=1&country=uk&apikey=#{rt_api_key}"
      end
      
      response = JSON.parse(Typhoeus.get(uri).body)
      movie_list = response["movies"]
      in_theaters = []

      movie_list.each do |movie|
        if enough_info?(movie)
          in_theaters << movie_info(movie['id'])
        end
      end
      Aggregator.clean_up(in_theaters)
      return in_theaters
    end

    private

    # Aggregates exta information about a movie that cannot be derived directly from the
    # Rotten Tomatoes API e.g IMDb/Metacritic rating, HQ posters
    # @param movie [Movie] the movie to aggregate information for
    # @return [Movie] the movie passed in with aggregated info completed
    def aggregate

      retrieve_imdb_info
      retrieve_metacritic_info
      get_poster
      get_reviews

      return @movie
    end

    def retrieve_imdb_info
      omdb_response = JSON.parse(Typhoeus.get("http://www.omdbapi.com/?i=tt#{@movie.imdb_id}").body)

      if omdb_response["Response"] == "True"
        @movie.imdb_rating = omdb_response["imdbRating"]
      else
        @movie.imdb_rating = "Unavailable"
      end
    end

    def retrieve_metacritic_info
      # Extract Metacritic rating (IMDB has a page listing MC reviews)
      metacritic_page = Nokogiri::HTML(open("http://www.metacritic.com/search/"\
                        "movie/#{CGI.escape(@movie.title)}/results"))

      scraped_rating = metacritic_page.css('.first_result .metascore_w').text
      metacritic_url = "http://www.metacritic.com#{metacritic_page.at_css('.first_result a').attr(:href)}"
      
      # If attempt to scrape results in empty string, info must not be available
      if scraped_rating == ""
        scraped_rating = "No Rating"
        metacritic_url = "No URL"
      end

      @movie.metacritic_rating = scraped_rating
      @movie.metacritic_url = metacritic_url
    end

    # Retrieves the URL of a high resolution poster of a movie
    # @params imdb_id [String] the IMDb ID of the required movie (without 'tt' prefixed)
    # @return [String] the URL of the poster as a string
    def get_poster
      uri = "#{TMDB_API_BASE_URL}/movie/tt#{@movie.imdb_id}?api_key=#{tmdb_api_key}"
      movie_info = JSON.parse(Typhoeus.get(uri).body)

      if movie_info.has_key?("poster_path")
        @movie.poster = "http://cf2.imgobject.com/t/p/original" + movie_info["poster_path"]
      else
        @movie.poster = "No poster available"
      end
    end

    def get_reviews
      uri = "#{RT_API_BASE_URL}/movies/#{@movie.rt_id}/reviews.json?review_type=top_critic"\
            "&page_limit=5&page=1&country=uk&apikey=#{rt_api_key}"
      review_hash = JSON.parse(Typhoeus.get(uri).body)

      review_list = []

      review_hash["reviews"].each do |review|
        review_list << WrittenReview.new(review)
      end

      @movie.reviews = review_list
    end

    # Checks that a given movie has enough information available via API to aggregate
    # data. It MUST have an IMDb id and a release date.
    # @param [Hash] the hash representation of the movie to check
    # @return [Boolean] whether the movie has a theater release date and IMDb ID
    def enough_info?(movie)

      has_release_date = false
      has_imdb_id = false

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
