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
    end

    # Retrieve the details of a specific movie using its Rotten Tomatoes ID
    #
    # @param rt_id [String] the Rotten Tomatoes ID of the movie
    # @return [Movie] a Movie object representing the movie
    def aggregate_movie(rt_id)

      # Get the basic movie info first using the RottenTomatoes API
      movie = RottenTomatoes::MovieInfoFetcher.new(rt_api_key).fetch_info(rt_id)

      movie.imdb_rating = IMDB::RatingFetcher.fetch(movie.imdb_id)

      metacritic_info = Metacritic::RatingFetcher.fetch(movie.title)
      movie.metacritic_rating = metacritic_info[:metacritic_rating]
      movie.metacritic_url = metacritic_info[:metacritic_url]

      movie.poster = TMDB::PosterFetcher.new(@tmdb_api_key).fetch(movie.imdb_id)
      movie.reviews = ReviewsFetcher.new(@rt_api_key).fetch(movie.rt_id)
      @movie = movie
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
  end
end
