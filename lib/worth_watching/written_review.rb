require 'date'

module WorthWatching
  class WrittenReview
    attr_accessor :author, :date, :rating, :source, :quote, :link, :original_score

    def initialize(author, date, rating, source, quote, link, original_score)
      @author = author
      @date = date
      @rating = rating
      @source = source
      @quote = quote
      @link = link
      @original_score = original_score
    end

    def to_s
      "#{author} wrote on #{date} : #{quote}\nRating: #{@original_score}"
    end

    def to_hash
      { author: author,
        date: date,
        rating: rating,
        source: source,
        quote: quote,
        link: link,
        original_score: original_score
      }
    end
  end
end
