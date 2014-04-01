require 'date'

module WorthWatching
  class Movie
    attr_accessor :title, :plot, :director, :genre, :rt_rating, :rt_url, :cast,
                  :imdb_rating, :imdb_url, :metacritic_rating, :metacritic_url,
                  :release_date, :poster, :rt_id, :imdb_id, :reviews

    def initialize(movie_params)

      @title = movie_params['title']
      @plot = movie_params['synopsis']
      @director = movie_params['abridged_directors'][0]['name']
      @genre = movie_params['genres'][0]
      @rt_rating = movie_params['ratings']['critics_score']
      @rt_url = movie_params['links']['alternate']
      @cast = build_cast_list(movie_params['abridged_cast'])
      @imdb_id = movie_params['alternate_ids']['imdb']
      @imdb_url = "http://www.imdb.com/title/tt#{imdb_id}/"
      @release_date = Date.parse(movie_params['release_dates']['theater'])
      @rt_id = movie_params['id'].to_s

      @imdb_rating = "Not retrieved"
      @metacritic_rating = "Not retrieved"
    end

    # Returns a summary of the movie based on its attributes
    #
    # @return [String] the summary
    def summary
      divider = "-" * 60
      "#{divider}\n#{@title}\n#{divider}\nReleased: #{@release_date.strftime("%d %b %Y")}\n#{divider}\n#{plot}\n#{divider}\nCast: #{@cast}\n#{divider}\n#{rating_summary}\n"
    end

    def rating_summary
      "Rotten Tomatoes rating: #{rt_rating}\nIMDB rating: #{imdb_rating}\nMetacritic rating: #{metacritic_rating}\n"
    end

    private

    # Builds a cast list string from an array of actor names (up to 4 actors)
    #
    # @param cast [Array] the array of actor names
    # @return [String] a string of actor names separated by commas
    def build_cast_list(cast)
      cast_list = cast[0..3].inject("") do |cast_list_string, actor, i|
        cast_list_string << "#{actor["name"]}, "
      end

      # Remove the trailing comma
      cast_list.sub(/, \z/, "")
    end
  end
end
