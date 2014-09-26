require 'spec_helper'

describe "WorthWatching::RottenTomatoes::MovieInfoFetcher" do
  before do
    # Single movie RottenTomatoes
    json_response = File.read(File.dirname(__FILE__) + "/../../support/json_responses/toy_story_rt.json")
    stub_request(:get, /api\.rottentomatoes\.com\/api\/public\/v1\.0\/movies\/770672122\.json\?apikey\=.*/).to_return(:status => 200, :body => json_response,:headers => {"content-type"=>["application/json; charset=utf-8"]})
  end

  let(:fetcher) { WorthWatching::RottenTomatoes::MovieInfoFetcher.new("rt_api_key") }

  let(:movie) { fetcher.fetch_info("770672122") }

  describe "the Movie object returned" do
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

    it "has a placeholder IMDb rating'" do
      expect(movie.imdb_rating).to eq("Not retrieved")
    end

    it "has a placeholder Metacritic rating'" do
      expect(movie.imdb_rating).to eq("Not retrieved")
    end
  end
end
