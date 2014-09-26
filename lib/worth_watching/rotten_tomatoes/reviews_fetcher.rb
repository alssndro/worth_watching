module WorthWatching
  module RottenTomatoes
    class ReviewsFetcher

      # Fetches reviews using the Rotten Tomatoes API, 
      # and returns an array of WrittenReview objects
      def self.fetch(rt_id, rt_api_key)
        uri = "#{WorthWatching::RT_API_BASE_URL}/movies/#{rt_id}/reviews.json?review_type=top_critic"\
              "&page_limit=5&page=1&country=uk&apikey=#{rt_api_key}"
        reviews_response = JSON.parse(Typhoeus.get(uri).body)

        ReviewParser.parse(reviews_response)
      end
    end
  end
end
