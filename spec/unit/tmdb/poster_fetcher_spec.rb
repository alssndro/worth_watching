require 'spec_helper'

describe "WorthWatching::TMDB::PosterFetcher" do
  before do
    json_response = File.read(File.dirname(__FILE__) + "/../../support/json_responses/toy_story_tmdb.json")
    stub_request(:get, /api\.themoviedb\.org\/3\/movie\/tt0435761\?api_key\=.*/).to_return(:status => 200, :body => json_response,:headers => {"content-type"=>["application/json; charset=utf-8"]})
  end

  let(:movie_imdb_id) { "0435761" }
  let(:poster_fetcher) { WorthWatching::TMDB::PosterFetcher.new("tmdb_api_key") }
  it "retrieves a URL of the movie's poster" do
    poster_url = poster_fetcher.fetch(movie_imdb_id)
    expect(poster_url).to eq("http://cf2.imgobject.com/t/p/original/tOwAAVeL1p3ls9dhOBo45ElodU3.jpg")
  end
end
