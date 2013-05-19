require 'date'

module WorthWatching
  class WrittenReview
    attr_accessor :author, :date, :rating, :source, :quote, :link

    def initialize(review_hash)
      @author = review_hash["critic"]
      @date = Date.parse(review_hash["date"])
      @rating = review_hash["freshness"]
      @source = review_hash["publication"]
      @quote = review_hash["quote"]
      @link = review_hash["links"]["review"]
    end

    def to_s
      "#{author} wrote on #{date} : #{quote}"
    end

    def to_hash
      hash = {author: author, date: date, rating: rating, source: source, 
              quote: quote, link: link}
    end
  end
end