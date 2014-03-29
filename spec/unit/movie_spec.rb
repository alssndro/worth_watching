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
end
