require 'test_helper'

describe "WorthWatching::WrittenReview" do
  let (:review) do
    WorthWatching::WrittenReview.new(
      "Joshua Rothkopf",
      Date.parse("2014-03-27"),
      "fresh",
      "Time Out New York",
      "The Marvel faithful will turn up for the action scenes, and the directors, brothers Anthony and Joe Russo, add an uncommon sharpness to sequences of urban warfare -- these Heat-grade bullet volleys have a real ping to them.",
      "http://www.timeout.com/us/film/captain-america-the-winter-soldier",
      "4/5"
      )
  end

  it "has a valid constructor" do
    expect(review).to be_an_instance_of(WorthWatching::WrittenReview)
  end

  it "can be converted back to a hash" do
    expect(review.to_hash).to eq({ author: "Joshua Rothkopf",
                                   date: Date.parse("2014-03-27"),
                                   rating: "fresh",
                                   source: "Time Out New York",
                                   quote: "The Marvel faithful will turn up for the action scenes, and the directors, brothers Anthony and Joe Russo, add an uncommon sharpness to sequences of urban warfare -- these Heat-grade bullet volleys have a real ping to them.",
                                   link: "http://www.timeout.com/us/film/captain-america-the-winter-soldier",
                                   original_score: "4/5"})
  end

  it "returns a formatted string representing the review" do
    expect(review.to_s).to eq("Joshua Rothkopf wrote on 2014-03-27 : The Marvel faithful will turn up for the action scenes, and the directors, brothers Anthony and Joe Russo, add an uncommon sharpness to sequences of urban warfare -- these Heat-grade bullet volleys have a real ping to them.\nRating: 4/5")
  end
end
