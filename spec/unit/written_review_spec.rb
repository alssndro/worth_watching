require 'test_helper'

describe "WorthWatching::WrittenReview" do
  let (:review) {WorthWatching::WrittenReview.new( {"critic"=>"Joshua Rothkopf", "date"=>"2014-03-27", "original_score"=>"4/5", "freshness"=>"fresh", "publication"=>"Time Out New York", "quote"=>"The Marvel faithful will turn up for the action scenes, and the directors, brothers Anthony and Joe Russo, add an uncommon sharpness to sequences of urban warfare -- these Heat-grade bullet volleys have a real ping to them.", "links"=>{"review"=>"http://www.timeout.com/us/film/captain-america-the-winter-soldier"}})}

  it "has a valid constructor" do
    expect(review).to be_an_instance_of(WorthWatching::WrittenReview)
  end

  it "has an author" do
    expect(review.author).to eq("Joshua Rothkopf")
  end

  it "has a date" do
    expect(review.date).to eq(Date.parse("2014-03-27"))
  end

  it "has a rating" do
    expect(review.rating).to eq("fresh")
  end

  it "has the original score" do
    expect(review.original_score).to eq("4/5")

  end

  it "has a source" do
    expect(review.source).to eq("Time Out New York")
  end

  it "has a quote" do
    expect(review.quote).to eq("The Marvel faithful will turn up for the action scenes, and the directors, brothers Anthony and Joe Russo, add an uncommon sharpness to sequences of urban warfare -- these Heat-grade bullet volleys have a real ping to them.")
  end

  it "has a link" do
    expect(review.link).to eq("http://www.timeout.com/us/film/captain-america-the-winter-soldier")
  end

  it "returns a formatted string representing the review" do
    expect(review.to_s).to eq("Joshua Rothkopf wrote on 2014-03-27 : The Marvel faithful will turn up for the action scenes, and the directors, brothers Anthony and Joe Russo, add an uncommon sharpness to sequences of urban warfare -- these Heat-grade bullet volleys have a real ping to them.\nRating: 4/5")
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
end
