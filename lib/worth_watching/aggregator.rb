require 'httparty'
require 'nokogiri'
require 'open-uri'

module WorthWatching
  class Aggregator

    attr_accessor :rt_api_key, :tmdb_api_key

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
    def movie_info(rt_id)
      uri = "#{RT_API_BASE_URL}/movies/#{rt_id}.json?apikey=#{rt_api_key}"
      movie_hash = HTTParty.get(uri)

      aggregate(Movie.new(movie_hash))
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
      return in_theaters
    end

    # Aggregates exta information about a movie that cannot be derived directly from the
    # Rotten Tomatoes API e.g IMDb/Metacritic rating, HQ posters
    # @param movie [Movie] the movie to aggregate information for
    # @return [Movie] the movie passed in with aggregated info completed
    def aggregate(movie)
      extra_info = get_extra_info_via_omdb(movie.imdb_id)

      movie.imdb_rating = extra_info[:imdb_rating]
      movie.metacritic_rating = extra_info[:metacritic_rating]
      movie.metacritic_url = extra_info[:metacritic_url]

      movie.poster = get_poster(movie.imdb_id)
      movie.reviews = get_reviews(movie.rt_id)

      return movie
    end

    private

    # Retrieves extra info about a particular movie that cannot be found using
    # the Rotten Tomatoes API. All facilitated by its IMDb ID.
    # @params imdb_id [String] the IMDb ID of the required movie (without 'tt' prefixed)
    # @return [Hash] a hash containing IMDb rating, Metacritic rating and movie URL
    def get_extra_info(imdb_id)
      imdb_url = "http://m.imdb.com/title/tt#{imdb_id}"

      imdb_page = Nokogiri::HTML(open(imdb_url))
      extra_info = {}

      # Extract IMDB rating
      extra_info[:imdb_rating] = imdb_page.css('.votes strong').text

      # Extract Metacritic rating (IMDB has a page listing MC reviews)
      imdb_mc_page = Nokogiri::HTML(open("http://www.imdb.com/title/tt#{imdb_id}/criticreviews"))

      mc_rating = imdb_mc_page.css(".metascore > span").text

      if mc_rating != ""
        extra_info[:metacritic_rating] = mc_rating
        extra_info[:metacritic_url] = imdb_mc_page.css(".see-more .offsite-link")[0]["href"]
      else
        extra_info[:metacritic_rating] = "No Rating"
        extra_info[:metacritic_url] = "No URL"
      end

      return extra_info
    end

    def get_extra_info_via_omdb(imdb_id)
      extra_info = {}
      omdb_response = HTTParty.get("http://www.omdbapi.com/?i=tt#{imdb_id}")

      if omdb_response["Response"] == "True"
        imdb_rating = omdb_response["imdbRating"]
        movie_title = omdb_response["Title"]

        # Extract Metacritic rating (IMDB has a page listing MC reviews)
        metacritic_page = Nokogiri::HTML(open("http://www.metacritic.com/search/"\
                          "movie/#{CGI.escape(movie_title)}/results"))
        mc_rating = metacritic_page.css('.first_result .metascore_w').text
        mc_link = "http://www.metacritic.com#{metacritic_page.at_css('.first_result a').attr(:href)}"
      else
        imdb_rating = "Unavailable"
      end

      # Extract IMDB rating
      extra_info[:imdb_rating] = imdb_rating

      if mc_rating != ""
        extra_info[:metacritic_rating] = mc_rating
        extra_info[:metacritic_url] = mc_link
      else
        extra_info[:metacritic_rating] = "Unavailable"
        extra_info[:metacritic_url] = "No URL"
      end

      return extra_info
    end



    # Retrieves the URL of a high resolution poster of a movie
    # @params imdb_id [String] the IMDb ID of the required movie (without 'tt' prefixed)
    # @return [String] the URL of the poster as a string
    def get_poster(imdb_id)
      uri = "#{TMDB_API_BASE_URL}/movie/tt#{imdb_id}?api_key=#{tmdb_api_key}"
      movie_info = HTTParty.get(uri, :headers => { 'Accept' => 'application/json'})

      if movie_info.has_key?("poster_path")
        "http://cf2.imgobject.com/t/p/original" + movie_info["poster_path"]
      else
        "No poster available"
      end
    end

    def get_reviews(rt_id)
      uri = "#{RT_API_BASE_URL}/movies/#{rt_id}/reviews.json?review_type=top_critic"\
            "&page_limit=5&page=1&country=uk&apikey=#{rt_api_key}"
      review_hash = HTTParty.get(uri)

      review_list = []

      review_hash["reviews"].each do |review|
        review_list << WrittenReview.new(review)
      end

      return review_list
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
