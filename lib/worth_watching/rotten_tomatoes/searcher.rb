require 'typhoeus'
require 'json'
require 'cgi'

module WorthWatching
  module RottenTomatoes
    class Searcher

      def initialize(rt_api_key)
        @rt_api_key = rt_api_key
      end

      # Search for movies using a query string. Returns a max of 4 results
      #
      # @param movie_title [String] the title of the movie to search for
      # @param result_limit [Integer] the max number of results to return
      # @return [Array, false] an array containing hashes represting each movie in the search results, or
      #   false if no results are found.
      def search_by_title(movie_title, result_limit)
        uri = "http://api.rottentomatoes.com/api/public/v1.0/movies.json?apikey=#{@rt_api_key}&q=#{CGI::escape(movie_title)}&page_limit=#{result_limit}"

        response = JSON.parse(Typhoeus.get(uri).body)

        if response["total"] == 0
          return false
        else
          # Build the array of movie serach results. Have to use a regexp to extract the Rotten Tomatoes
          # ID from the movie link since the API does not return it directly.
          return response["movies"].inject([]) do |movie_list, movie|
            movie_list << { :title => movie["title"], :rt_id => movie["links"]["self"].match(/\/[0-9]+\./).to_s.gsub(/[\/\.]/, ""), :year => movie["year"].to_s }
            movie_list
          end
        end
      end
    end
  end
end
