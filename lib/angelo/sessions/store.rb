module Angelo
  module Sessions
    class Store

      def initialize secret, length, name
        @secret = secret
        @length = length
        @name = name
      end

      def generate_id
        SecureRandom.uuid
      end

      # CONTRACT - LOAD
      #
      # You must implement a load method that takes a single id and
      # returns a hash of session values
      def load id
      end

      # CONTRACT - SAVE
      #
      # You must implement a save method that takes an id and a
      # hash of session values and save them in a retrieveable way
      # returns a hash of session values
      def save id, fields
      end

    end
  end
end