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

      raise(InsufficientDataError, "No IMDb ID present, can't aggregate") if movie.imdb_id == nil

      movie.imdb_rating = IMDB::RatingFetcher.fetch(movie.imdb_id)

      metacritic_info = Metacritic::RatingFetcher.fetch(movie.title)
      movie.metacritic_rating = metacritic_info[:metacritic_rating]
      movie.metacritic_url = metacritic_info[:metacritic_url]

      movie.poster = TMDB::PosterFetcher.new(@tmdb_api_key).fetch(movie.imdb_id)
      movie.reviews = ReviewsFetcher.new(@rt_api_key).fetch(movie.rt_id)
      @movie = movie
    end
  end
end
