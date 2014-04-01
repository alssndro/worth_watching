require 'date'

module WorthWatching
  class WrittenReview
    attr_accessor :author, :date, :rating, :source, :quote, :link, :original_score

    def initialize(review_hash)
      @author = review_hash["critic"]
      @date = Date.parse(review_hash["date"])
      @rating = review_hash["freshness"]
      @source = review_hash["publication"]
      @quote = review_hash["quote"]
      @link = review_hash["links"]["review"]
      @original_score = review_hash["original_score"] || "N/A"
    end

    def to_s
      "#{author} wrote on #{date} : #{quote}\nRating: #{@original_score}"
    end

    def to_hash
      { author: @author,
        date: @date,
        rating: @rating,
        source: @source,
        quote: @quote,
        link: @link,
        original_score: @original_score
      }
    end
  end
end
