require 'pry'
require 'json'

module Example
  class RatingsAggregation
    QUERY_JSON = {
      "query" => {
          "match_all" => {}
      },
      "size" => 0,
      "facets" => {
        "ratings" => {
          "terms_stats" => {
            "key_field" => "movie_id",
            "value_field" => "rating",
            "size" => 10000
          }
        }
      }
    }

    attr_reader :client

    def initialize(es_client)
      @client = es_client
    end

    def fetch_hash
      response = client.with(index: 'movies', type: 'rating').search(QUERY_JSON)
      aggs = response['facets']['ratings']['terms']
      Hash[ *aggs.collect{ |v| [v['term'], v] }.flatten ]
    end
  end
end
