require 'pry'
require 'json'

module Example
  class RatingsAggregation
    QUERY_JSON =
    {
      "query" => {
        "match_all" => {}
      },
      "size" => 0,
      "aggs" => {
        "ratings" => {
          "terms" => {
            "field" => "movie_id"
          },
          "aggs" => {
            "rating_stats" => {
              "stats" => {
                "field" => "rating"
              }
            }
          }
        }
      }
    }

    attr_reader :client

    def initialize(es_client)
      @client = es_client
    end

    def fetch_hash
      response = client.search index: 'movies', type: 'rating', body: QUERY_JSON
      aggs = response['aggregations']['ratings']['buckets']
      Hash[ *aggs.collect{ |v| [v['term'], v] }.flatten ]
    end
  end
end
