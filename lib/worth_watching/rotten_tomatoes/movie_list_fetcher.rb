module WorthWatching
  module RottenTomatoes
    class MovieListFetcher
      attr_accessor :rt_api_key

      def initialize(rt_api_key)
        @rt_api_key = rt_api_key
      end

      # Retrieve a list of basic movie information
      #
      # @param list_name [Symbol] type of list to retrieve, options:
      # :box_office, :in_theaters, :opening, :upcoming, :top_rentals, 
      # :current_releases, :new_releases, :upcoming_dvd
      # @param country [Symbol] Country code for region-specific results (ISO 3166-1 alpha-2)
      # @param result_limit [Symbol] no. of results to return, up to 16
      # @return [Array] an array of results, each representing a movie in the list
      def fetch_list(list_name, country, result_limit)
        case list_name
          # Build the appropriate URI based on the list name.
          # Some endpoints use 'limit' to specify max results to return, some use 'page_limit'.
          # Pass both to make the code simpler
          when :box_office, :in_theaters, :opening, :upcoming
            uri = "#{WorthWatching::RT_API_BASE_URL}/lists/movies/#{list_name.to_s}.json?limit=#{result_limit}"\
                  "&page_limit=#{result_limit}&page=1&country=#{country.to_s}&apikey=#{@rt_api_key}"
          when :top_rentals, :current_releases, :new_releases, :upcoming_dvd

            # The API endpoint uses 'upcoming' for both DVD and cinema releases
            # Need to avoid this clash by using ':upcoming_dvd' as possible method param,
            # but change back when building the URI
            list_name = :upcoming if list_name == :upcoming_dvd
            uri = "#{WorthWatching::RT_API_BASE_URL}/lists/dvds/#{list_name.to_s}.json?limit=#{result_limit}"\
                  "&page_limit=#{result_limit}&page=1&country=#{country.to_s}&apikey=#{@rt_api_key}"
        end

        response = JSON.parse(Typhoeus.get(uri).body)

        response["movies"].map do |movie_hash|
          { title: movie_hash["title"],
            rt_id: movie_hash["id"],
            year: movie_hash["year"].to_s,
            rt_rating: movie_hash["ratings"]["critics_score"]
          }
        end
      end
    end
  end
end
