module WorthWatching
  class RottenTomatoesMovieParser

    # Parses a single movie JSON response from the Rotten Tomatoes API, returning
    # a Movie object containing the movie's details
    def self.parse(json_response)
      title = json_response['title']
      plot = json_response['synopsis']
      director = json_response['abridged_directors'][0]['name']
      genre = json_response['genres'][0]
      rt_rating = json_response['ratings']['critics_score']
      rt_url = json_response['links']['alternate']

      cast = build_cast_list(json_response['abridged_cast'])
      imdb_id = json_response['alternate_ids']['imdb']
      imdb_url = "http://www.imdb.com/title/tt#{imdb_id}/"
      release_date = Date.parse(json_response['release_dates']['theater'])
      rt_id = json_response['id'].to_s

      Movie.new(title, plot, director, genre, rt_rating, rt_url, cast,
                  imdb_id, imdb_url, release_date, rt_id)
    end

    private

    # Builds a cast list string from an array of actor names (up to 4 actors)
    #
    # @param cast [Array] the array of actor names
    # @return [String] a string of actor names separated by commas
    def self.build_cast_list(cast)
      cast_list = cast[0..3].inject("") do |cast_list_string, actor, i|
        cast_list_string << "#{actor["name"]}, "
      end

      # Remove the trailing comma
      cast_list.sub(/, \z/, "")
    end
  end
end
