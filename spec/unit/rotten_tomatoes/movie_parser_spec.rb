require 'test_helper'
require 'json'

describe "WorthWatching::RottenTomatoes::MovieParser" do
  let (:api_response) do
    JSON.parse(File.read(File.dirname(__FILE__) + "/../support/json_responses/toy_story_rt.json"))
  end

  it "returns a Movie object representing the movie in the response" do
    movie = WorthWatching::RottenTomatoes::MovieParser.parse(api_response)
    expect(movie).to be_a(WorthWatching::Movie)
  end

  describe "the Movie object created after parsing" do
    let (:movie) { movie = WorthWatching::RottenTomatoes::MovieParser.parse(api_response) }
    it "has the correct movie title" do
      expect(movie.title).to eq("Toy Story 3")
    end      

    it "has the correct movie cast" do
      expect(movie.cast).to eq("Tom Hanks, Tim Allen, Joan Cusack, Ned Beatty")
    end

    it "has director 'Lee Unkrich'" do
      expect(movie.director).to eq("Lee Unkrich")
    end

    it "creates a printable string of cast members from an array of individual actors" do
      expect(movie.cast).to eq("Tom Hanks, Tim Allen, Joan Cusack, Ned Beatty")
    end

    it "has the title 'Toy Story 3" do
      expect(movie.title).to eq("Toy Story 3")
    end

    it "has the correct plot'" do
      expect(movie.plot).to eq("Pixar returns to their first success with Toy Story 3. The movie begins with Andy leaving for college and donating his beloved toys -- including Woody (Tom Hanks) and Buzz (Tim Allen) -- to a daycare. While the crew meets new friends, including Ken (Michael Keaton), they soon grow to hate their new surroundings and plan an escape. The film was directed by Lee Unkrich from a script co-authored by Little Miss Sunshine scribe Michael Arndt. ~ Perry Seibert, Rovi")
    end

    it "has a link to RT page 'http://www.rottentomatoes.com/m/toy_story_3/'" do
      expect(movie.rt_url).to eq("http://www.rottentomatoes.com/m/toy_story_3/")
    end

    it "has imdb url 'http://www.imdb.com/title/tt0435761/" do
      expect(movie.imdb_url).to eq("http://www.imdb.com/title/tt0435761/")
    end

    it "has the release date '2010-06-18'" do
      expect(movie.release_date).to eq(Date.new(2010, 06, 18))
    end

    it "has the genre 'Animation'" do
      expect(movie.genre).to eq("Animation")
    end
  end
end
