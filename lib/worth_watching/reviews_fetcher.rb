module WorthWatching

  # General class to fetch movie reviews for a given movie
  # Currently only supports RottenTomatoes as the source
  class ReviewsFetcher
    attr_accessor :rt_api_key

    def initialize(rt_api_key)
      @rt_api_key = rt_api_key
    end

    def fetch(rt_id)
      RottenTomatoes::ReviewsFetcher.fetch(rt_id, rt_api_key)
    end
  end
end
