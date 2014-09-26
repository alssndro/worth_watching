require 'spec_helper'
require 'json'

describe "WorthWatching::Movie" do
  let(:movie) do
    WorthWatching::Movie.new("Toy Story 3",
              "Pixar returns to their first success with Toy Story 3. The movie begins with Andy leaving for college and donating his beloved toys -- including Woody (Tom Hanks) and Buzz (Tim Allen) -- to a daycare. While the crew meets new friends, including Ken (Michael Keaton), they soon grow to hate their new surroundings and plan an escape. The film was directed by Lee Unkrich from a script co-authored by Little Miss Sunshine scribe Michael Arndt. ~ Perry Seibert, Rovi",
              "Lee Unkrich",
              "Animation",
              "99",
              "http://www.rottentomatoes.com/m/toy_story_3/",
              "Tom Hanks, Tim Allen, Joan Cusack, Ned Beatty",
              "0435761",
              "http://www.imdb.com/title/tt0435761/",
              Date.parse("2010-06-18"),
              "770672122"
              )
  end

  it "has a valid constructor" do
      expect(movie).to be_an_instance_of(WorthWatching::Movie)
  end

  it "returns a general summary" do
    summary = "------------------------------------------------------------\nToy Story 3\n------------------------------------------------------------\nReleased: 18 Jun 2010\n------------------------------------------------------------\nPixar returns to their first success with Toy Story 3. The movie begins with Andy leaving for college and donating his beloved toys -- including Woody (Tom Hanks) and Buzz (Tim Allen) -- to a daycare. While the crew meets new friends, including Ken (Michael Keaton), they soon grow to hate their new surroundings and plan an escape. The film was directed by Lee Unkrich from a script co-authored by Little Miss Sunshine scribe Michael Arndt. ~ Perry Seibert, Rovi\n------------------------------------------------------------\nCast: Tom Hanks, Tim Allen, Joan Cusack, Ned Beatty\n------------------------------------------------------------\nRotten Tomatoes rating: 99\nIMDB rating: Not retrieved\nMetacritic rating: Not retrieved\n\n"

    expect(movie.summary).to eq(summary)
  end

  it "returns a rating summary" do
    summary = "Rotten Tomatoes rating: 99\nIMDB rating: Not retrieved\nMetacritic rating: Not retrieved\n"
    expect(movie.rating_summary).to eq(summary)
  end
end
