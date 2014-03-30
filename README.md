# WorthWatching

WorthWatching is a gem that allows you to aggregate movie review data from a 
number of different sources.

Current supported sources are Rotten Tomatoes, IMDb and Metacritic.

## Installation

Add this line to your application's Gemfile:
```ruby
gem 'worth_watching'
```
And then execute:

    $ bundle

Or install it yourself as:

    $ gem install worth_watching

## Setup

* Apply for the required API keys. You will need a [Rotten Tomatoes API Key](http://developer.rottentomatoes.com/)  and a [TMDB API key](http://docs.themoviedb.apiary.io/).

* Fill in the details of your API keys in config/config.yml

## Usage

```ruby
# Create a new aggregator
movie_aggregator = WorthWatching::Aggregator.new("rotten_tomatoes_api_key", "tmdb_api_key")

# Search for movie by Rotten Tomatoes ID
toy_story_3 = movie_aggregator.movie_info('770672122')

# We now have a Movie object and can access many attributes, including rating information
toy_story_3.title 
=> "Toy Story 3"

toy_story_3.rt_rating
=> 99

toy_story_3.imdb_rating
=> 85

toy_story_3.metacritic_rating
=> 92


# Get a short 5-film list of movies currently on release 
recent_movies = movie_aggregator.in_cinemas(5)

iron_man = recent_movies.first

iron_man.title
=> "Iron Man 3"

critic_review = iron_man.reviews.first
critic_review.quote
=> "The trouble is that, as the plot quickens, any cleverness withdraws, to make 
    way for the firecrackers of the climax. That is not Black's forte, and his 
    movie duly slumps into a mess."
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
