require "worth_watching/version"
require 'worth_watching/aggregator'
require 'worth_watching/movie'
require 'worth_watching/written_review'
require 'worth_watching/errors'

require 'worth_watching/rotten_tomatoes/rotten_tomatoes'
require 'worth_watching/rotten_tomatoes/movie_parser'
require 'worth_watching/rotten_tomatoes/review_parser'
require 'worth_watching/rotten_tomatoes/reviews_fetcher'
require 'worth_watching/rotten_tomatoes/movie_info_fetcher'
require 'worth_watching/rotten_tomatoes/movie_list_fetcher'
require 'worth_watching/rotten_tomatoes/searcher'

require 'worth_watching/imdb/rating_fetcher'

require 'worth_watching/metacritic/rating_fetcher'

require 'worth_watching/reviews_fetcher'

require 'worth_watching/tmdb/poster_fetcher'

module WorthWatching
end
