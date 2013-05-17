#worth_watching_spec.rb
require 'vcr_setup'
require 'worth_watching'

describe 'WorthWatching' do

  let(:aggregator) {WorthWatching::Aggregator.new}

  describe 'get individual movie info' do

    let(:movie) do
      VCR.use_cassette('toy story 3') do
      aggregator.movie_info("770672122") 
      end
    end

    let(:release_date)  { Date.new(2010, 06, 18) }

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
      movie.release_date.should == release_date
    end

    it "should have director 'Lee Unkrich'" do
      movie.director.should == "Lee Unkrich"
    end

    it "should have genre 'Animation'" do
      movie.genre.should == "Animation"
    end

    it "should have poster url 'http://cf2.imgobject.com/t/p/original/b0qY6gl1nOeGNJpa9s0ansJrjrs.jpg'" do
      movie.poster.should == "http://cf2.imgobject.com/t/p/original/b0qY6gl1nOeGNJpa9s0ansJrjrs.jpg"
    end
  end

  describe "Retrieve movies currently in cinemas" do

    let(:movies) do 
      VCR.use_cassette('in cinemas') do
        aggregator.in_cinemas 
      end
    end

    it "should return a non-empty array of movies" do
      movies.size.should_not == 0
    end
  end

end