# WorthWatching

WorthWatching is a gem that allows you to aggregate movie review data from a
number of different sources.

Current supported sources are Rotten Tomatoes, IMDb and Metacritic.

Note that the success of the aggregation process is entirely dependent on knowing
the Rotten Tomatoes ID first. This is because, assuming we know the Rotten Tomatoes ID of a movie, we can get the IMDB ID of the same movie from the RT API, but we cannot find the Rotten Tomato movie ID from an IMDB ID.

However, you can use `my_aggregator.search("movie title")` to first search for a movie by title. The search results include the Rotten Tomatoes ID, which you can then use aggregate movie info as usual with `aggregator.aggregate_movie("rt_id")`.

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

* Apply for the required API keys. You will need a [Rotten Tomato API Key](http://developer.rottentomatoes.com/)  and a [TMDB API key](http://docs.themoviedb.apiary.io/).

* Fill in the details of your API keys in config/config.yml

## Usage

```ruby
# Create a new aggregator
movie_aggregator = WorthWatching::Aggregator.new("rotten_tomato_api_key", "tmdb_api_key")

# Search for movies by title. Returns an array of hashes, each hash representing a movie in the search result
# Note that it returns the Rotten Tomato ID for each movie, which is vital to aggregation
movie_aggregator.search_by_title("the godfather")
=> [{:title=>"The Godfather", :rt_id=>"12911", :year=>"1972"}, {:title=>"The Godfather, Part II", :rt_id=>"12926", :year=>"1974"}, {:title=>"The Godfather, Part III", :rt_id=>"13476", :year=>"1990"}, {:title=>"The Godfather of Green Bay", :rt_id=>"341816359", :year=>"2005"}]

# To aggregate movie info, pass the movie's Rotten Tomatoes ID
toy_story_3 = movie_aggregator.aggregate_movie("770672122")

# We now have a Movie object and can access many attributes, including rating information
toy_story_3.title
=> "Toy Story 3"

# Get a general summary
puts toy_story_3.summary
=> "Toy Story 3
------------------------------------------------------------
Released: 18 Jun 2010
------------------------------------------------------------
Pixar returns to their first success with Toy Story 3. The movie begins with Andy leaving for college and donating his beloved toys -- including Woody (Tom Hanks) and Buzz (Tim Allen) -- to a daycare. While the crew meets new friends, including Ken (Michael Keaton), they soon grow to hate their new surroundings and plan an escape. The film was directed by Lee Unkrich from a script co-authored by Little Miss Sunshine scribe Michael Arndt. ~ Perry Seibert, Rovi
------------------------------------------------------------
Cast: Tom Hanks, Tim Allen, Joan Cusack, Ned Beatty
------------------------------------------------------------
Rotten Tomatoes rating: 99
IMDB rating: 8.5
Metacritic rating: 92"

# Get just the rating summary
puts toy_story_3.rating_summary
=> "Rotten Tomatoes rating: 99
IMDB rating: 8.5
Metacritic rating: 92"

# Or individual ratings
toy_story_3.rt_rating
=> 99

toy_story_3.imdb_rating
=> 8.5

toy_story_3.metacritic_rating
=> 92


# You can also retrieve multiple movies based on a common list, such as the latest 4 releases
# in cinemas/theaters, or DVD. 
recent_movies = movie_aggregator.latest_releases(:cinema, 4)

# Or the top 6 releases in cinema/theater or on DVD
top_movies = movie_aggregator.top_releases(:dvd, 6)

# The above list-based methods return an array of Movie objects
iron_man = recent_movies.first

iron_man.title
=> "Iron Man 3"

critic_review = iron_man.reviews.first
critic_review.quote
=> "The trouble is that, as the plot quickens, any cleverness withdraws, to make
    way for the firecrackers of the climax. That is not Black's forte, and his
    movie duly slumps into a mess."
```
