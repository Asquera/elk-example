require 'pry'

module Example
  class DataSetLoader
    attr_reader :dataset_dir
    attr_reader :genres

    def initialize(dataset_dir)
      @dataset_dir = dataset_dir
      @genres = load_genres('u.genre')
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

    def create_movie_seed_file(input_file, output_file)
      File.open(File.join(dataset_dir, input_file), 'r:iso-8859-1') do |file|
        file.each_line do |line|
          components = line.chomp.split("|")
          id           = components[0]
          title        = components[1]
          release_date = components[2]
          video_date   = components[3]
          imdb_url     = components[4]
          genre        = detect_genres(components[5..-1].map{ |i| Integer(i) })
        end
      end
    end

    def detect_genres(list)
      list.each_index.select{ |i| list[i] > 0 }
    end
  end
end
