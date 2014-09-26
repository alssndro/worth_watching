require 'spec_helper'

describe "WorthWatching::RottenTomatoes::MovieListFetcher" do
  before do
    json_response = File.read(File.dirname(__FILE__) + "/../../support/json_responses/rt_top_16_in_cinemas.json")
    stub_request(:get, "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=rt_api_key&country=uk&limit=16&page=1&page_limit=16").
             with(:headers => {'User-Agent'=>'Typhoeus - https://github.com/typhoeus/typhoeus'}).
             to_return(:status => 200, :body => json_response, :headers => {})
  end

  let(:movie_info_fetcher) { WorthWatching::RottenTomatoes::MovieListFetcher.new("rt_api_key") }
  let(:movies) { movie_info_fetcher.fetch_list(:in_theaters, :uk, 16) }

  it "retrieves an array of Hash objects, each representing a movie result in the list" do
    expect(movies).to be_a(Array)
    movies.each {|movie| expect(movie).to be_a(Hash)}
  end

  describe "a single movie result in the movies list" do
    let(:movie_result) { movies.first }

    it "has the title of the movie" do
      expect(movie_result[:title]).to eq("The Lego Movie")
    end

    it "has the Rotten Tomatoes ID of the movie" do
      expect(movie_result[:rt_id]).to eq("771305753")
    end

    it "has the year the movie was released" do
      expect(movie_result[:year]).to eq("2014")
    end

    it "has the year the movie was released" do
      expect(movie_result[:rt_rating]).to eq(97)
    end
  end
end
