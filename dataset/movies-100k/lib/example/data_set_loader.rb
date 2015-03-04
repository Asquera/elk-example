require 'pry'

module Example
  class DataSetLoader
    attr_reader :dataset_dir

    def initialize(dataset_dir)
      @dataset_dir = dataset_dir
      @genres = load_genres('u.genre')
    end

    def load_genres(filename)
      result = {}
      File.open(File.join(dataset_dir, filename)) do |file|
        file.each_line do |line|
          title, index  = line.split('|')
          result[index] = title
        end
      end
      result
    end

    def create_movie_seed_file(input_file, output_file)
      File.open(File.join(dataset_dir, input_file), 'r') do |file|
        file.each_line do |line|
          components = line.split("\t")
          id           = components[0]
          title        = components[1]
          release_date = components[2]
          video_date   = components[3]
          imdb_url     = components[4]
          genre        = components[5..-1].map{ || }
          binding.pry
        end
      end
    end
  end
end
