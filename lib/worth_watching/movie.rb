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
      @cast = extract_cast(movie_params['abridged_cast'])
      @imdb_id = movie_params['alternate_ids']['imdb']
      @imdb_url = "http://www.imdb.com/title/tt#{imdb_id}/"
      @release_date = Date.parse(movie_params['release_dates']['theater'])
      @rt_id = movie_params['id']
    end

    private

    def extract_cast(cast)
      cast_list = ""
      # Extract the first 4 actors, formatting with a comma when necessary
      cast[0..3].each_with_index do |actor, i| 
        actor = (i < 3) ? "#{actor['name']}, " : "#{actor['name']}"
        cast_list << actor
      end
      return cast_list
    end
  end
end