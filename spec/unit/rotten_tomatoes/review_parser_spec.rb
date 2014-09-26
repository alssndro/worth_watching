require 'spec_helper'
require 'json'

describe "WorthWatching::RottenTomatoesReviewParser" do
  let (:review_response_hash) do
    JSON.parse(File.read(File.dirname(__FILE__) + "/../../support/json_responses/toy_story_reviews_rt.json"))
  end

  it "returns an array of Review objects representing the review in the response" do
    reviews = WorthWatching::RottenTomatoes::ReviewParser.parse(review_response_hash)
    expect(reviews).to be_a(Array)
    reviews.each { |review| expect(review).to be_a(WorthWatching::WrittenReview) }
  end

  describe "the WrittenReview object created after parsing" do
    let (:review) { WorthWatching::RottenTomatoes::ReviewParser.parse(review_response_hash).last }
    
    it "has an author" do
      expect(review.author).to eq("Ailsa Caine")
    end

    it "has a date" do
      expect(review.date).to eq(Date.parse("2010-07-22"))
    end

    it "has a rating" do
      expect(review.rating).to eq("fresh")
    end

    it "has the original score" do
      expect(review.original_score).to eq("4/5")

    end

    it "has a source" do
      expect(review.source).to eq("Little White Lies")
    end

    it "has a quote" do
      expect(review.quote).to eq("By [Pixar's] high standards this isn't the best, but by anyone else's, it's close to perfection.")
    end

    it "has a link" do
      expect(review.link).to eq("http://www.littlewhitelies.co.uk/theatrical-reviews/toy-story-3/")
    end
  end
end
