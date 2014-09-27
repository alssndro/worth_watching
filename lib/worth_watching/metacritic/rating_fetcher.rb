require 'typhoeus'
require 'nokogiri'
require 'cgi'

module WorthWatching
  module Metacritic
    class RatingFetcher

      # Fetches movie info of a single movie using the Rotten Tomatoes API, 
      # and returns a Movie object
      def self.fetch(movie_title)
        metacritic_page = Nokogiri::HTML(Typhoeus.get("http://www.metacritic.com/search/"\
                                         "movie/#{CGI.escape(movie_title)}/results").body)

        scraped_rating = metacritic_page.css('.first_result .metascore_w').text.to_i
        metacritic_url = "http://www.metacritic.com#{metacritic_page.at_css('.first_result a').attr(:href)}"

        # If attempt to scrape results in empty string, info must not be available
        if scraped_rating == ""
          scraped_rating = "No Rating"
          metacritic_url = "No URL"
        end
        
        { metacritic_rating: scraped_rating, metacritic_url: metacritic_url }
      end
    end
  end
end
