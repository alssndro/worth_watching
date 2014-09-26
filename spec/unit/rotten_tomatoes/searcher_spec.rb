require 'spec_helper'

describe "WorthWatching::RottenTomatoes::Searcher" do
  describe "searching for movies" do
    before do
      json_response = File.read(File.dirname(__FILE__) + "/../../support/json_responses/1_movie_search_result.json")
      stub_request(:get, /api\.rottentomatoes\.com\/api\/public\/v1\.0\/movies\.json\?apikey=.*&page_limit=4&q=finding%20nemo/).to_return(:status => 200, :body => json_response,:headers => {"content-type"=>["application/json; charset=utf-8"]})

      json_response = File.read(File.dirname(__FILE__) + "/../../support/json_responses/3_movie_search_result.json")
      stub_request(:get, /api\.rottentomatoes\.com\/api\/public\/v1\.0\/movies\.json\?apikey=.*&page_limit=4&q=toy%20story/).to_return(:status => 200, :body => json_response,:headers => {"content-type"=>["application/json; charset=utf-8"]})

      json_response = File.read(File.dirname(__FILE__) + "/../../support/json_responses/0_movie_search_result.json")
      stub_request(:get, /api\.rottentomatoes\.com\/api\/public\/v1\.0\/movies\.json\?apikey=.*&page_limit=4&q=amoviethatdoesnotexist/).to_return(:status => 200, :body => json_response,:headers => {"content-type"=>["application/json; charset=utf-8"]})
    end

    let(:searcher) { WorthWatching::RottenTomatoes::Searcher.new("rt_api_key") }
    
    context "when results exist for the given query string" do
      let(:results) { searcher.search_by_title("finding nemo", 4) }

      describe "the search results" do
        it "is an array of movies" do
          expect(results).to be_an_instance_of(Array)
        end

        it "has the title of the movie result" do
          expect(results.first[:title]).to eq("Finding Nemo")
        end

        it "has the Rotten Tomatoes ID of the movie result" do
          expect(results.first[:rt_id]).to eq("9377")
        end

        it "has the release year of the movie result" do
          expect(results.first[:year]).to eq("2003")
        end
      end
    end

    context "when results do not exist for the given query string" do
      describe "the search results" do
        it "returns false" do
          results = searcher.search_by_title("amoviethatdoesnotexist", 4)
          expect(results).to be_false
        end
      end
    end
  end
end
