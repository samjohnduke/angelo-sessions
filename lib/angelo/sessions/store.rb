module Angelo
  module Sessions
    class Store

      attr_reader :secret, :length, :name

      def initialize secret, length, name
        @secret = secret
        @length = length
        @name = name
      end

      def expires
        (Time.now + length).rfc2822
      end

      def generate_id
        SecureRandom.uuid
      end

      # CONTRACT - LOAD
      #
      # You must implement a fetch method that takes a single id and
      # returns a hash of session values
      def fetch id
        raise NotImplementedError
      end

      # CONTRACT - SAVE
      #
      # You must implement a save method that takes an id and a
      # hash of session values and save them in a retrieveable way
      # returns a hash of session values
      def save id, fields
        raise NotImplementedError
      end

    end
  end
end
