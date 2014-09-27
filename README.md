![WorthWatching logo](logo.png)

## WorthWatching

WorthWatching is a gem that aggregates movie review data from a
number of different sources.

Currently, the supported info sources are [Rotten Tomatoes](http://rottentomatoes.com), [IMDb](http://imdb.com) and [Metacritic](http://metacritic.com).

### What info does WorthWatching aggregate?

The gem was designed to retrieve the overall rating form each source. But it also
retrieves extra info that may be useful.

The full list of info retrieved for each movie:

- title
- plot (no spoilers, just the general description)
- director
- cast
- genre
- release date
- **Rotten Tomatoes rating (n out of 100)**
- **IMDb rating (n out of 10)**
- **Metacritic rating (n out of 100)**
- Rotten Tomatoes movie URL
- IMDb movie URL
- Metacritic movie URL
- Rotten Tomaotes movie ID
- IMDb movie ID
- poster image URL
- reviews

Note that the success of the aggregation process is entirely dependent on knowing
the Rotten Tomatoes ID *first*.

However, you can use the `search_by_title` method to first search for a movie.
The search results include the Rotten Tomatoes ID, which you can then use aggregate movie info as
usual with the `aggregate_movie` method.

If you would like to know why this is the case, or are just interested in how aggregation happens,
[read here](https://github.com/alessndro/worth_watching/wiki/F.A.Q) for some extra information.

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

- Apply for the required API keys. You will need a [Rotten Tomatoes API Key](http://developer.rottentomatoes.com/)  and a [TMDB API key](http://docs.themoviedb.apiary.io/).


## Usage

### Getting started
```ruby
# Create a new aggregator, passing in your API keys
movie_aggregator = WorthWatching::Aggregator.new("rotten_tomato_api_key", "tmdb_api_key")
```

### Searching for a movie by title

Pass the title of the movie, and the maximum number of results to return

```ruby
# Search for movies by title. Returns an array of hashes, each hash representing
# a movie in the search result
# Note that it returns the Rotten Tomatoes ID for each movie, which is vital to aggregation
searcher = WorthWatching::RottenTomatoes::Searcher.new("rt_api_key")
searcher.search_by_title("the godfather", 4)
=> [{:title=>"The Godfather", :rt_id=>"12911", :year=>"1972"},
{:title=>"The Godfather, Part II", :rt_id=>"12926", :year=>"1974"},
{:title=>"The Godfather, Part III", :rt_id=>"13476", :year=>"1990"},
{:title=>"The Godfather of Green Bay", :rt_id=>"341816359", :year=>"2005"}]
```

### Retrieving info for a single movie
```ruby

# Pass the movie's Rotten Tomatoes ID
toy_story_3 = movie_aggregator.aggregate_movie("770672122")

# We now have a Movie object and can access many attributes...
toy_story_3.title
=> "Toy Story 3"
```

### Rating Info
```ruby
# Access ratings individually
toy_story_3.rt_rating
=> 99

toy_story_3.imdb_rating
=> 8.5

toy_story_3.metacritic_rating
=> 92

# Get the rating summary as a string
puts toy_story_3.rating_summary
=> "Rotten Tomatoes rating: 99
IMDB rating: 8.5
Metacritic rating: 92"
```
### General movie info
```ruby
toy_story_3.plot
=> "Pixar returns to their first success with Toy Story 3. The movie begins with
Andy leaving for college and donating his beloved toys -- including Woody
(Tom Hanks) and Buzz (Tim Allen) -- to a daycare. While the crew meets new friends,
including Ken (Michael Keaton), they soon grow to hate their new surroundings and
plan an escape. The film was directed by Lee Unkrich from a script co-authored by
Little Miss Sunshine scribe Michael Arndt. ~ Perry Seibert, Rovi"

toy_story_3.director
=> "Lee Unkrich"

toy_story_3.cast
=> "Tom Hanks, Tim Allen, Joan Cusack, Ned Beatty"

toy_story_3.genre
=> "Animation"

toy_story_3.release_date
=> #<Date: 2010-06-18 ((2455366j,0s,0n),+0s,2299161j)>

# Rotten Tomatoes URL
toy_story_3.rt_url
=> "http://www.rottentomatoes.com/m/toy_story_3/"

toy_story_3.imdb_url
=> "http://www.imdb.com/title/tt0435761/"

toy_story_3.metacritic_url
=> "http://www.metacritic.com/movie/toy-story-3"

# Rotten Tomatoes ID
toy_story_3.rt_id
=> "770672122"

toy_story_3.imdb_id
=> "0435761"

toy_story_3.poster
=> "http://cf2.imgobject.com/t/p/original/tOwAAVeL1p3ls9dhOBo45ElodU3.jpg"

# Get a general summary
puts toy_story_3.summary
=> "Toy Story 3
------------------------------------------------------------
Released: 18 Jun 2010
------------------------------------------------------------
Pixar returns to their first success with Toy Story 3. The movie begins with Andy
leaving for college and donating his beloved toys -- including Woody (Tom Hanks)
and Buzz (Tim Allen) -- to a daycare. While the crew meets new friends,
including Ken (Michael Keaton), they soon grow to hate their new surroundings
and plan an escape. The film was directed by Lee Unkrich from a script
co-authored by Little Miss Sunshine scribe Michael Arndt. ~ Perry Seibert, Rovi
------------------------------------------------------------
Cast: Tom Hanks, Tim Allen, Joan Cusack, Ned Beatty
------------------------------------------------------------
Rotten Tomatoes rating: 99
IMDB rating: 8.5
Metacritic rating: 92"
```

### Movie reviews
Sourced from Rotten Tomatoes. ``Movie`` object has an instance variable ``reviews``,
which is an array of ``WrittenReview`` objects.

```ruby
# Get the first review
a_review = toy_story_3.reviews.last
a_review.author
=> "Ailsa Caine"

a_review.date
=> #<Date: 2010-07-22 ((2455400j,0s,0n),+0s,2299161j)>

a_review.quote
=> "By [Pixar's] high standards this isn't the best, but by anyone else's, it's close to perfection."

# Reviews are those collated by Rotten Tomatoes, where the review scale is binary ("fresh" or "rotten")
a_review.rating
=> "fresh"

# The review's original score (not always available)
a_review.original_score
=> "4/5"

a_review.source
=> "Little White Lies"

a_review.link
=> "http://www.littlewhitelies.co.uk/theatrical-reviews/toy-story-3/"

# Convenience method to summarise the review as a string
a_review.to_s
=> "Ailsa Caine wrote on 2010-07-22 : By [Pixar's] high standards this isn't the best, but by anyone else's, it's close to perfection.
Rating: 4/5"
```

### Aggregating a list of movies
The Rotten Tomatoes API supports a number of pre-defined lists for both cinema/theater
releases and DVD releases.

Pass the name of the list you would like to process (as a Symbol), the country code
(ISO 3166-1 alpha-2) of the country you would like info to be localised to (as a Symbol),
and finally, the maximum number of movies on the list you are interested in.

The available lists mirror those available through the Rotten Tomatoes API.

They are:

- ``:box_office`` - top box office earning movies, sorted by most recent weekend gross
ticket sales
- ``:in_theaters`` - movies currently in theaters/cinemas
- ``:opening`` - current opening movies in the theaters/cinema
- ``:upcoming`` - upcoming movies in theaters/cinema
- ``:top_rentals`` - top DVD rentals
- ``:current_releases`` - current DVD releases
- ``:new_releases`` - new DVD releases
- ``:upcoming_dvd`` - upcoming DVD releases

**The Rotten Tomatoes API
does have rate limits (as of March 2014: 5 calls a second, 10,000 calls a day)**

```ruby
# Create a new fetcher using your API key
list_fetcher = WorthWatching::RottenTomatoes::MovieListFetcher.new("rt_api_key")

# Get the top 4 box office movies in the UK
list_fetcher.fetch_list(:box_office, :uk, 4)
=> [{:title=>"A Most Wanted Man", :rt_id=>"771314084", :year=>"2014", :rt_rating=>91},
 {:title=>"Before I Go to Sleep", :rt_id=>"771367646", :year=>"2014", :rt_rating=>58},
 {:title=>"Let's Be Cops", :rt_id=>"771372963", :year=>"2014", :rt_rating=>20},
 {:title=>"Magic in the Moonlight", :rt_id=>"771367659", :year=>"2014", :rt_rating=>51}]

# Or the top 6 releases on DVD in the US
top_dvds = list_fetcher.fetch_list(:top_rentals, :us, 6)
=> [{:title=>"Captain America: The Winter Soldier", :rt_id=>"771312513", :year=>"2014", :rt_rating=>89},
 {:title=>"The Amazing Spider-Man 2", :rt_id=>"771249926", :year=>"2014", :rt_rating=>53},
 {:title=>"Godzilla", :rt_id=>"771225175", :year=>"2014", :rt_rating=>73},
 {:title=>"Neighbors", :rt_id=>"771308254", :year=>"2014", :rt_rating=>73},
 {:title=>"Divergent", :rt_id=>"771315918", :year=>"2014", :rt_rating=>41},
 {:title=>"Noah", :rt_id=>"771305170", :year=>"2014", :rt_rating=>77}]

# The above list-based methods return an array of hashes, each representing a result
number_1_dvd = top_dvds.first
=> {:title=>"Captain America: The Winter Soldier", :rt_id=>"771312513", :year=>"2014", :rt_rating=>89}

# Use the rt_id (Rotten Tomato ID) to subsequently aggregate movie info
aggregated_results = top_dvds.map { |movie| aggregator.aggregate_movie(movie[:rt_id]) }

```

### Why is the returned list empty?

This may be because some movies do not have the minimum amount of data available
in order to aggregate their rating info, and are therefore 'discarded' during the aggregation
process.

If a movie's IMDb ID is not available through the Rotten Tomatoes API, rating info
cannot be retrieved.

During testing I also noticed that movies with no available release date were likely
to be very obscure and not have any rating info associated with them either. This is
the other criteria for a movie being discarded.

This only tends to happen with very small release independent films, particularly foreign ones.

The lists where the above is most likely are ``:upcoming`` and ``:upcoming_dvd``, since they
contain movies that probably don't have any rating info yet, as they haven't been released.

The opposite is true for lists like ``:box_office`` and ``top_rentals``.
