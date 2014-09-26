module WorthWatching
  module RottenTomatoes
    class MovieInfoFetcher
      attr_accessor :rt_api_key

      def initialize(rt_api_key)
        @rt_api_key = rt_api_key
      end

      # Fetches movie info of a single movie using the Rotten Tomatoes API, 
      # and returns a Movie object
      def fetch_info(rt_id)
        uri = "#{WorthWatching::RT_API_BASE_URL}/movies/#{rt_id}.json?apikey=#{rt_api_key}"
        movie_hash = JSON.parse(Typhoeus.get(uri).body)

        RottenTomatoes::MovieParser.parse(movie_hash)
      end
    end
  end
end
