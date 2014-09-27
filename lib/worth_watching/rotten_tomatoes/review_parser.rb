module WorthWatching
  module RottenTomatoes
    class ReviewParser

      # Parses a JSON response of movie reviews from the Rotten Tomatoes API, returning
      # an array WrittenReview objects
      def self.parse(json_response)
        json_response["reviews"].map do |review_hash|
          author = review_hash["critic"]
          date = Date.parse(review_hash["date"])
          rating = review_hash["freshness"]
          source = review_hash["publication"]
          quote = review_hash["quote"]
          link = review_hash["links"]["review"]
          original_score = review_hash["original_score"] || "N/A"

          WrittenReview.new(author, date, rating, source, quote, link, original_score)
        end
      end
    end
  end
end
