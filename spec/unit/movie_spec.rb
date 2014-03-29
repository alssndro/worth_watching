require 'test_helper'
require 'json'

describe "WorthWatching::Movie" do
  let(:movie) do
    response_movie_hash = File.read(File.dirname(__FILE__) + "/../support/json_responses/toy_story.json")
    WorthWatching::Movie.new(JSON.parse(response_movie_hash))
  end

  it "has a valid constructor" do
      expect(movie).to be_an_instance_of(WorthWatching::Movie)
  end

  it "creates a printable string of cast members from an array of individual actors" do
    expect(movie.cast).to eq("Tom Hanks, Tim Allen, Joan Cusack, Ned Beatty")
  end

  it "should have the title 'Toy Story 3" do
    expect(movie.title).to eq("Toy Story 3")
  end

  it "should have correct plot'" do
    expect(movie.plot).to eq("Pixar returns to their first success with Toy Story 3. The movie begins with Andy leaving for college and donating his beloved toys -- including Woody (Tom Hanks) and Buzz (Tim Allen) -- to a daycare. While the crew meets new friends, including Ken (Michael Keaton), they soon grow to hate their new surroundings and plan an escape. The film was directed by Lee Unkrich from a script co-authored by Little Miss Sunshine scribe Michael Arndt. ~ Perry Seibert, Rovi")
  end

  it "should have a link to RT page 'http://www.rottentomatoes.com/m/toy_story_3/'" do
    expect(movie.rt_url).to eq("http://www.rottentomatoes.com/m/toy_story_3/")
  end

  it "should have imdb url 'http://www.imdb.com/title/tt0435761/" do
    expect(movie.imdb_url).to eq("http://www.imdb.com/title/tt0435761/")
  end

  it "should have release date '2010-06-18'" do
    expect(movie.release_date).to eq(Date.new(2010, 06, 18))
  end

  it "should have director 'Lee Unkrich'" do
    expect(movie.director).to eq("Lee Unkrich")
  end

  it "should have genre 'Animation'" do
    expect(movie.genre).to eq("Animation")
  end
end
