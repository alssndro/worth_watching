require 'spec_helper'

describe "WorthWatching::IMDB::RatingFetcher" do
  before do
    # Single movie OMDB (Toy Story 3)
    json_response = File.read(File.dirname(__FILE__) + "/../../support/json_responses/toy_story_omdb.json")
    stub_request(:get, "http://www.omdbapi.com/?i=tt0435761").to_return(:status => 200, :body => json_response)

    # Single movie OMDB (Captain America)
    json_response = File.read(File.dirname(__FILE__) + "/../../support/json_responses/captain_america_omdb.json")
    stub_request(:get, "http://www.omdbapi.com/?i=tt1843866").to_return(:status => 200, :body => json_response)

    # IMDb movie webpage (Captain America)
    json_response = File.read(File.dirname(__FILE__) + "/../../support/html_responses/captain_america_imdb.html")
    stub_request(:get, "http://m.imdb.com/title/tt1843866/").to_return(:status => 200, :body => json_response)
  end

  context "when the rating is available using the OMDB API" do
    it "returns the correct IMDb rating via the OMDB API" do
      rating = WorthWatching::IMDB::RatingFetcher.fetch("0435761")
      expect(rating).to eq(8.5)
    end
  end

  context "when the rating is not available using the OMDB API" do
    it "returns the correct IMDb rating by screenscraping its IMDb webpage" do
      rating = WorthWatching::IMDB::RatingFetcher.fetch("1843866")
      expect(rating).to eq(8.3)
    end
  end
end
