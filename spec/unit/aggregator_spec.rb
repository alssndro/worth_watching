require 'test_helper'

describe 'WorthWatching::Aggregator' do

  let(:aggregator) {WorthWatching::Aggregator.new("rt_api_key", "tmdb_api_key")}

  describe 'get individual movie info' do

    before do
      json_response = File.read(File.dirname(__FILE__) + "/../support/json_responses/toy_story.json")
      stub_request(:get, /api\.rottentomatoes\.com\/api\/public\/v1\.0\/movies\/770672122\.json\?apikey\=.*/).to_return(:status => 200, :body => json_response)
    end

    let(:movie) { aggregator.movie_info("770672122") }

    it "should have the title 'Toy Story 3" do
      movie.title.should == "Toy Story 3"
    end

    it "should have correct plot'" do
      movie.plot.should == "Pixar returns to their first success with Toy Story 3. The movie begins with Andy leaving for college and donating his beloved toys -- including Woody (Tom Hanks) and Buzz (Tim Allen) -- to a daycare. While the crew meets new friends, including Ken (Michael Keaton), they soon grow to hate their new surroundings and plan an escape. The film was directed by Lee Unkrich from a script co-authored by Little Miss Sunshine scribe Michael Arndt. ~ Perry Seibert, Rovi"
    end

    it "should have rotten tomatoes rating 99'" do
      movie.rt_rating.should == 99
    end

    it "should have a link to RT page 'http://www.rottentomatoes.com/m/toy_story_3/'" do
      movie.rt_url.should == "http://www.rottentomatoes.com/m/toy_story_3/"
    end

    it "should have imdb rating of 8.5" do
      movie.imdb_rating.should == "8.5"
    end

    it "should have imdb url 'http://www.imdb.com/title/tt0435761/" do
      movie.imdb_url.should == "http://www.imdb.com/title/tt0435761/"
    end

    it "should have metacritic rating of 92" do
      movie.metacritic_rating.should == "92"
    end

    it "should have metacritic url 'http://www.metacritic.com/movie/toy-story-3'" do
      movie.metacritic_url.should == "http://www.metacritic.com/movie/toy-story-3"
    end

    it "should have cast 'Tom Hanks, Tim Allen, Joan Cusack, Ned Beatty'" do
      movie.cast.should == "Tom Hanks, Tim Allen, Joan Cusack, Ned Beatty"
    end

    it "should have release date '2010-06-18'" do
      movie.release_date.should == Date.new(2010, 06, 18)
    end

    it "should have director 'Lee Unkrich'" do
      movie.director.should == "Lee Unkrich"
    end

    it "should have genre 'Animation'" do
      movie.genre.should == "Animation"
    end

    it "should have the correct poster url" do
      movie.poster.should == "http://cf2.imgobject.com/t/p/original/tOwAAVeL1p3ls9dhOBo45ElodU3.jpg"
    end

    describe "movie reviews" do
      it "should have an author" do
        #puts movie.reviews.first.to_hash
      end

      it "should have a date" do

      end

      it "should have rating" do

      end

      it "should have a source" do

      end

      it "should have a review quote" do

      end

      it "should have a link to the review" do

      end
    end
  end

  describe "Retrieve movies currently in cinemas" do

    let(:movies) do
      # stub aggregator.in_cinemas(16, :cinema)
    end

    it "should return a non-empty array of movies" do
      movies.size.should_not == 0
    end

    it "all movies should have a release date" do
      movies.each {|movie| movie.release_date.should_not == nil}
    end

    it "all movies should have a poster url" do
      movies.each {|movie| puts "#{movie.title} #{movie.rt_rating} | #{movie.imdb_rating} | #{movie.metacritic_rating}"; movie.poster.should_not == nil}
      puts "___________________________________________________"
    end
  end

  describe "Retrieve movies released on DVD" do

    let(:movies) do
      # stub
      aggregator.in_cinemas(16, :dvd)
    end

    it "should return a non-empty array of movies" do
      movies.size.should_not == 0
    end

    it "all movies should have a release date" do
      movies.each {|movie| movie.release_date.should_not == nil}
    end

    it "all movies should have a poster url" do
      movies.each {|movie| puts "#{movie.title} #{movie.rt_rating} | #{movie.imdb_rating} | #{movie.metacritic_rating}"; movie.poster.should_not == nil}
    end
  end
end
