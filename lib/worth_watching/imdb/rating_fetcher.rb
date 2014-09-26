module WorthWatching
  module IMDB
    class RatingFetcher

      # Fetches movie info of a single movie using the Rotten Tomatoes API, 
      # and returns a Movie object
      def self.fetch(imdb_id)
        omdb_response = JSON.parse(Typhoeus.get("http://www.omdbapi.com/?i=tt#{imdb_id}").body)

        if omdb_response["Response"] == "True"
          if omdb_response["imdbRating"] == "N/A"
            scrape_imdb_rating(imdb_id)
          else
            imdb_rating = omdb_response["imdbRating"]
          end
        else
          imdb_rating = "Unavailable"
        end
      end

      private 

      # Scrapes and sets the IMDb rating of the current movie from its IMDb page
      def self.scrape_imdb_rating(imdb_id)
        imdb_url = "http://m.imdb.com/title/tt#{imdb_id}/"

        imdb_page = Nokogiri::HTML(Typhoeus.get(imdb_url).body)

        imdb_page.xpath("//*[@class = 'mobile-sprite yellow-star']").first.next_element.text.match(/[0-9]\.[0-9]/).to_s.to_f
      end

    end
  end
end
