require 'date'
require 'nokogiri'
require 'open-uri'
require 'pry'

module WorthWatching
  class Movie
    attr_accessor :title, :plot, :director, :genre, :rt_rating, :rt_url, :cast,
                  :imdb_rating, :imdb_url, :metacritic_rating, :metacritic_url, 
                  :release_date, :poster

    def initialize(movie_params, tmdb_api_key)
      
      @title = movie_params['title']
      @plot = movie_params['synopsis']
      @director = movie_params['abridged_directors'][0]['name']
      @genre = movie_params['genres'][0]

      @rt_rating = movie_params['ratings']['critics_score']
      @rt_url = movie_params['links']['alternate']
      @cast = extract_cast(movie_params['abridged_cast'])

      # The IMDB ID allows us to retrieve both the rating and URL of the movie on
      # IMDB and Metacritic
      imdb_id = movie_params['alternate_ids']['imdb']
      @imdb_url = "http://www.imdb.com/title/tt#{imdb_id}/"
      alternate_info = get_alternate_info(imdb_id)
      @imdb_rating = alternate_info[:imdb_rating]
      @metacritic_rating = alternate_info[:metacritic_rating]
      @metacritic_url = alternate_info[:metacritic_url]    
      @release_date = extract_date(movie_params['release_dates']['theater'])

      @poster = get_poster(imdb_id, tmdb_api_key)
    end

    private

    # Retrieves extra info about a particular movie that cannot be found using
    # the Rotten Tomatoes API. All facilitated by its IMDb ID.
    # @params imdb_id [String] the IMDb ID of the required movie (without 'tt' prefixed)
    # @return [Hash] a hash containing IMDb rating, Metacritic rating and movie URL
    def get_alternate_info(imdb_id)
      imdb_url = "http://m.imdb.com/title/tt#{imdb_id}"

      imdb_page = Nokogiri::HTML(open(imdb_url))
      alternate_info = {}

      # Extract IMDB rating
      alternate_info[:imdb_rating] = imdb_page.css('.votes strong').text

      # Extract Metacritic rating (IMDB has a page listing MC reviews)

      imdb_mc_page = Nokogiri::HTML(open("http://www.imdb.com/title/tt#{imdb_id}/criticreviews"))

      mc_rating = imdb_mc_page.css(".metascore > span").text

      if mc_rating != ""
        alternate_info[:metacritic_rating] = mc_rating
  
        alternate_info[:metacritic_url] = imdb_mc_page.css(".see-more .offsite-link")[0]["href"]
      else
        alternate_info[:metacritic_rating] = "No Rating"
        alternate_info[:metacritic_url] = "No URL" 
      end
 
      alternate_info
    end

    # Retrieves the URL of a high resolution poster of a movie
    # @params imdb_id [String] the IMDb ID of the required movie (without 'tt' prefixed)
    # @params tmdb_api_key [String] TMDB api key required to use their poster API
    # @return [String] the URL of the poster as a string
    def get_poster(imdb_id, tmdb_api_key)
      uri = "#{Aggregator::TMDB_BASE_URL}/movie/tt#{imdb_id}?api_key=#{tmdb_api_key}"
      movie_info = HTTParty.get(uri, :headers => { 'Accept' => 'application/json'})

      "http://cf2.imgobject.com/t/p/original" + movie_info["poster_path"] if movie_info.has_key?("poster_path")
    end

    def extract_cast(cast)
      cast_list = ""

      # Extract the first 4 actors, formatting with a comma when necessary
      cast[0..3].each_with_index do |actor, i| 
        actor = (i < 3) ? "#{actor['name']}, " : "#{actor['name']}"
        cast_list << actor
      end
      return cast_list
    end

    def extract_date(date)
      date_string = date.split("-")
      year, month, day = date_string[0].to_i, date_string[1].to_i, date_string[2].to_i
      Date.new(year, month, day)
    end

  end
end