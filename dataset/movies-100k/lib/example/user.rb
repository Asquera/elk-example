require 'virtus'

module Example
  class User
    include Virtus.model

    attribute :id, Integer
    attribute :age, Integer
    attribute :gender, String
    attribute :occupation, String
    attribute :zip_code, String
  end
end
