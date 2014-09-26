module WorthWatching
  module TMDB
    TMDB_API_BASE_URL = 'http://api.themoviedb.org/3'
    class PosterFetcher
      attr_accessor :tmdb_api_key

      def initialize(tmdb_api_key)
        @tmdb_api_key = tmdb_api_key
      end

      def fetch(imdb_id)
        uri = "#{TMDB::TMDB_API_BASE_URL}/movie/tt#{imdb_id}?api_key=#{tmdb_api_key}"
        movie_info = JSON.parse(Typhoeus.get(uri).body)

        if movie_info.has_key?("poster_path")
          "http://cf2.imgobject.com/t/p/original" + movie_info["poster_path"]
        else
          "No poster available"
        end
      end
    end
  end
end
