module WorthWatching
  class Movie
    attr_accessor :title, :plot, :director, :genre, :rt_rating, :rt_url, :cast,
                  :imdb_rating, :imdb_url, :metacritic_rating, :metacritic_url,
                  :release_date, :poster, :rt_id, :imdb_id, :reviews

    def initialize(title, plot, director, genre, rt_rating, rt_url, cast, imdb_id, 
                  imdb_url, release_date, rt_id)
      @title = title
      @plot = plot
      @director = director
      @genre = genre
      @rt_rating = rt_rating
      @rt_url = rt_url
      @cast = cast
      @imdb_id = imdb_id
      @imdb_url = imdb_url
      @release_date = release_date
      @rt_id = rt_id

      @imdb_rating = "Not retrieved"
      @metacritic_rating = "Not retrieved"
    end

    # Returns a summary of the movie based on its attributes
    #
    # @return [String] the summary
    def summary
      divider = "-" * 60
      "#{divider}\n#{@title}\n#{divider}\nReleased: " +
      "#{@release_date.strftime("%d %b %Y")}\n#{divider}\n#{plot}\n#{divider}" +
      "\nCast: #{@cast}\n#{divider}\n#{rating_summary}\n"
    end

    def rating_summary
      "Rotten Tomatoes rating: #{rt_rating}\nIMDB rating: #{imdb_rating}\n" +
      "Metacritic rating: #{metacritic_rating}\n"
    end
  end
end
