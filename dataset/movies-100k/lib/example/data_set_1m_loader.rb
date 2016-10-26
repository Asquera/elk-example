require 'date'

module Example
  class DataSet1MLoader
    attr_reader :dataset_dir
    attr_reader :genres

    GENDERS = {
      'M' => 'male',
      'F' => 'female'
    }

    OCCUPATIONS = {
      "0"  => "other",
      "1"  => "academic/educator",
      "2"  => "artist",
      "3"  => "clerical/admin",
      "4"  => "college/grad student",
      "5"  => "customer service",
      "6"  => "doctor/health care",
      "7"  => "executive/managerial",
      "8"  => "farmer",
      "9"  => "homemaker",
      "10" => "K-12 student",
      "11" => "lawyer",
      "12" => "programmer",
      "13" => "retired",
      "14" => "sales/marketing",
      "15" => "scientist",
      "16" => "self-employed",
      "17" => "technician/engineer",
      "18" => "tradesman/craftsman",
      "19" => "unemployed",
      "20" => "writer",
    }

    def initialize(dataset_dir)
      @dataset_dir = dataset_dir
    end

    def create_movie_seed_file(input_file, output)
      File.open(File.join(dataset_dir, input_file), 'r:iso-8859-1') do |file|
        file.each_line do |line|
          components = line.chomp.split("::")
          id           = components[0]
          title        = components[1]
          genre        = components[2].split('|')

          movie = Movie.new(
            id:    id,
            title: title,
            genre: genre
          )

          # write movie as ES bulk entries
          output << "{ \"index\": { \"_type\": \"movie\" } }\n"
          output << "{ \"id\": #{id}, \"title\": \"#{title}\", \"genre\": \"#{genre}\" }\n"
        end
      end
    end

    def create_user_seed_file(input_file, output)
      File.open(File.join(dataset_dir, input_file), 'r:iso-8859-1') do |file|
        file.each_line do |line|
          components = line.chomp.split("::")
          id         = components[0]
          gender     = GENDERS.fetch(components[1]) { 'unknown' }
          age        = Integer(components[2])
          occupation = OCCUPATIONS.fetch(components[3]) { 'unknown' }
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

    def create_ratings_seed_file(input_file, output)
      File.open(File.join(dataset_dir, input_file), 'r:iso-8859-1') do |file|
        file.each do |line|
          l = line.chomp.split("::")
          break if l.size < 4

          user_id   = l[0]
          movie_id  = l[1]
          ratings   = l[2]
          # transform seconds from epoch to milliseconds
          timestamp = Integer(l[3]) * 1000

          output << "{ \"index\": { \"_type\": \"rating\" } }\n"
          output << "{ \"user_id\": #{user_id}, \"movie_id\": #{movie_id}, \"rating\": #{ratings}, \"timestamp\": #{timestamp} }\n"
        end
      end
    end
  end
end
