require 'virtus'

module Example
  class Movie
    include Virtus.model

    attribute :id, Integer
    attribute :title, String, default: ''
    attribute :release_date, Date
    attribute :video_release_date, Date
    attribute :imdb_url, String
    attribute :genre, Array[String]
    attribute :num_ratings, Integer, default: 0
  end
end
