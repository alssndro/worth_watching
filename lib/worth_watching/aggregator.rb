require 'nokogiri'
require 'typhoeus'
require 'json'
require 'cgi'

module WorthWatching
  class Aggregator

    attr_accessor :rt_api_key, :tmdb_api_key
    attr_reader :movie

    def initialize(rt_api_key, tmdb_api_key)
      @rt_api_key = rt_api_key
      @tmdb_api_key = tmdb_api_key
      @movie = nil # the current movie being aggregated
    end

    # Retrieve the details of a specific movie using its Rotten Tomatoes ID
    #
    # @param rt_id [String] the Rotten Tomatoes ID of the movie
    # @return [Movie] a Movie object representing the movie
    def aggregate_movie(rt_id)

      # Get the basic movie info first using the RottenTomatoes API
      @movie = RottenTomatoes::MovieInfoFetcher.fetch(rt_id, rt_api_key)

      @movie.imdb_rating = IMDB::RatingFetcher.fetch(@movie.imdb_id)

      metacritic_info = Metacritic::RatingFetcher.fetch(@movie.title)
      @movie.metacritic_rating = metacritic_info[:metacritic_rating]
      @movie.metacritic_url = metacritic_info[:metacritic_url]

      @movie.poster = PosterFetcher.new(@tmdb_api_key).fetch(@movie.imdb_id)
      @movie.reviews = ReviewsFetcher.new(@rt_api_key).fetch(@movie.rt_id)
      @movie
    end

    # Retrieve a list of movies, then aggregate info for each one
    #
    # @param list_name[Symbol] the name of the Rotten Tomato list. Possible values: :box_office,
    #   :in_theaters, :opening, :upcoming, :top_rentals, :current_releases, :new_releases, :upcoming_dvd
    # @param country [Symbol] Localised data for the selected country (ISO 3166-1 alpha-2)
    # @param result_limit [Integer] the max number of movies to return in the list
    # @return [Array] an array of Movie objects
    def aggregate_list(list_name, country, result_limit)
      case list_name

        # Build the appropriate URI based on the list name.
        # Some enpoints use 'limit' to specify max results to return, some use 'page_limit'.
        # Pass both to make the code simpler
        when :box_office, :in_theaters, :opening, :upcoming
          uri = "#{WorthWatching::RT_API_BASE_URL}/lists/movies/#{list_name.to_s}.json?limit=#{result_limit}"\
                "&page_limit=#{result_limit}&page=1&country=#{country.to_s}&apikey=#{@rt_api_key}"
        when :top_rentals, :current_releases, :new_releases, :upcoming_dvd

          # The API endpoint uses 'upcoming' for both DVD and cinema releases
          # Need to avoid this clash by using ':upcoming_dvd' as possible method param,
          # but change back when building the URI
          list_name = :upcoming if list_name == :upcoming_dvd
          uri = "#{WorthWatching::RT_API_BASE_URL}/lists/dvds/#{list_name.to_s}.json?limit=#{result_limit}"\
                "&page_limit=#{result_limit}&page=1&country=#{country.to_s}&apikey=#{@rt_api_key}"
      end

      get_movie_list(uri)
    end

    # Search for movies using a query string. Returns a max of 4 results
    #
    # @param movie_title [String] the title of the movie to search for
    # @param result_limit [Integer] the max number of results to return
    # @return [Array, false] an array containing hashes represting each movie in the search results, or
    #   false if no results are found.
    def search_by_title(movie_title, result_limit)
      uri = "http://api.rottentomatoes.com/api/public/v1.0/movies.json?apikey=#{@rt_api_key}&q=#{CGI::escape(movie_title)}&page_limit=#{result_limit}"

      response = JSON.parse(Typhoeus.get(uri).body)

      if response["total"] == 0
        return false
      else
        # Build the array of movie serach results. Have to use a regexp to extract the Rotten Tomatoes
        # ID from the movie link since the API does not return it directly.
        return response["movies"].inject([]) do |movie_list, movie|
          movie_list << { :title => movie["title"], :rt_id => movie["links"]["self"].match(/\/[0-9]+\./).to_s.gsub(/[\/\.]/, ""), :year => movie["year"].to_s }
          movie_list
        end
      end
    end

    private

    # Checks that a given movie has enough information available via API to aggregate
    # data. It MUST have an IMDb id and a release date.
    #
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

    # Retrieves a list of movies from the Rotten Tomatoes API, then aggregates
    # info for each one
    #
    # @param uri [String] the Rotten Tomatoes API endpoint for the list
    # @return [Array] an array of Movie objects
    def get_movie_list(uri)
      response = JSON.parse(Typhoeus.get(uri).body)
      movie_list_response = response["movies"]

      movie_list = movie_list_response.inject([]) do |list, movie|
        list << aggregate_movie(movie['id']) if enough_info?(movie)
        list
      end

      return movie_list
    end
  end
end
