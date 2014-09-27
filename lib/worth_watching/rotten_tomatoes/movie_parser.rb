module WorthWatching
  module RottenTomatoes
    class MovieParser

      # Parses a single movie JSON response from the Rotten Tomatoes API, returning
      # a Movie object containing the movie's details
      def self.parse(json_response)
        movie_args = {}

        movie_args[:title] = json_response['title']
        movie_args[:plot] = json_response['synopsis']
        movie_args[:director] = json_response['abridged_directors'][0]['name'] if json_response.has_key?('abridged_directors')
        movie_args[:genre] = json_response['genres'][0] if json_response.has_key?('genres')

        movie_args[:rt_rating] = json_response['ratings']['critics_score']
        movie_args[:rt_url] = json_response['links']['alternate']

        movie_args[:cast] = build_cast_list(json_response['abridged_cast'])

        imdb_id = json_response['alternate_ids']['imdb'] if json_response.has_key?('alternate_ids')
        movie_args[:imdb_id] = imdb_id

        movie_args[:imdb_url] = "http://www.imdb.com/title/tt#{imdb_id}/"
        movie_args[:release_date] = Date.parse(json_response['release_dates']['theater'])
        movie_args[:rt_id] = json_response['id'].to_s

        Movie.new(movie_args)
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
end

