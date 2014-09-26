require 'spec_helper'

describe "WorthWatching::RottenTomatoes::ReviewsFetcher" do
  before do
    # Movie reviews from RottenTomatoes
    json_response = File.read(File.dirname(__FILE__) + "/../../support/json_responses/toy_story_reviews_rt.json")
    stub_request(:get, /api\.rottentomatoes\.com\/api\/public\/v1\.0\/movies\/770672122\/reviews\.json\?apikey\=.*&country=uk&page=1&page_limit=5&review_type=top_critic/).to_return(:status => 200, :body => json_response,:headers => {"content-type"=>["application/json; charset=utf-8"]})
  end

  let(:movie_rt_id) { "770672122" }

  it "retrieves a URL of the movie's poster" do
    reviews = WorthWatching::RottenTomatoes::ReviewsFetcher.fetch("770672122", "rt_api_key")

    expect(reviews).to be_a(Array)
    reviews.each { |review| expect(review).to be_a(WorthWatching::WrittenReview) }
  end
end
