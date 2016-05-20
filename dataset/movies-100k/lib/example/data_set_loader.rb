require 'date'

module Example
  class DataSetLoader
    attr_reader :dataset_dir
    attr_reader :genres
    attr_reader :client

    GENDERS = {
      'M' => 'male',
      'F' => 'female'
    }

    def initialize(dataset_dir, client)
      @dataset_dir = dataset_dir
      @genres  = load_genres('u.genre')
      @client  = client
      @ratings = {}
    end

    def load_genres(filename)
      result = {}
      File.open(File.join(dataset_dir, filename)) do |file|
        file.each_line do |line|
          title, index  = line.chomp.split('|')
          result[Integer(index)] = title if title && index
        end
      end
      result
    end

    def create_user_seed_file(input_file, output)
      File.open(File.join(dataset_dir, input_file), 'r:iso-8859-1') do |file|
        file.each_line do |line|
          components = line.chomp.split("|")
          id         = components[0]
          age        = Integer(components[1])
          gender     = GENDERS.fetch(components[2]) { 'unknown' }
          occupation = components[3]
          zip_code   = components[4]

          user = User.new(
            id:         id,
            age:        age,
            gender:     gender,
            occupation: occupation,
            zip_code:   zip_code
          )

          output << "{ \"index\": { \"_type\": \"user\" } }\n"
          output << "{ \"id\": #{id}, \"age\": #{age}, \"gender\": \"#{gender}\", \"occupation\": \"#{occupation}\", \"zip_code\": \"#{zip_code}\" }\n"
        end
      end
    end

    def create_movie_seed_file(input_file, output)
      File.open(File.join(dataset_dir, input_file), 'r:iso-8859-1') do |file|
        file.each_line do |line|
          components = line.chomp.split("|")

          id           = Integer(components[0])
          title        = components[1]
          release_date = components[2]
          video_date   = components[3]
          imdb_url     = components[4]
          genre        = detect_genres(components[5..-1].map{ |i| Integer(i) })

          movie = Movie.new(
            id:           id,
            title:        title,
            release_date: release_date,
            imdb_url:     imdb_url,
            genre:        genre,
          )

          if ratings = @ratings[id]
            if movie.num_ratings = ratings.count > 0
              movie.avg_rating = ratings.inject(0, &:+) / movie.num_ratings
            else
              movie.avg_rating = 0.0
            end
          end

          movie.video_release_date = video_date unless video_date.empty?

          output << { index: { '_type' => 'movie' } }.to_json + "\n"
          output << movie.attributes.to_json + "\n"
        end
      end
    end

    def create_ratings_seed_file(input_file, output)
      File.open(File.join(dataset_dir, input_file), 'r:iso-8859-1') do |file|
        file.each_line do |line|
          l = line.chomp.split("\t")

          user_id   = l[0]
          movie_id  = l[1]
          rating    = l[2]
          timestamp = Integer(l[3]) * 1000

          output << "{ \"index\": { \"_type\": \"rating\" } }\n"
          output << "{ \"user_id\": #{user_id}, \"movie_id\": #{movie_id}, \"rating\": #{rating}, \"timestamp\": #{timestamp} }\n"

          add_rating(movie_id, rating)
        end
      end
    end

    private

    def add_rating(movie_id, rating)
      (@ratings[movie_id] ||= []) << rating
    end

    def detect_genres(list)
      list.each_index.select{ |i| list[i] > 0 }.map{ |i| genres.fetch(i) }
    end
  end
end
