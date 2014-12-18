module Angelo
  module Sessions

    # Session bag will be the basic session accessor and in charge of parsing
    # and saving the session to the store as well as setting accessor id
    class Bag

      def initialize store, request
        if cookies = request.headers[COOKIE_KEY]
          cookies = cookies.first if Array === cookies
          cookies.split(SEMICOLON).each do |c|
            a = c.split(EQUALS).map &:strip
            @key = a[1] if a[0] == store.name
          end
        end

        @fields = Hash.new
        @store = store
      end

      def [] key
        get(key)
      end

      def []= key, value
        set(key, value)
      end

      def each &block
        fetch
        return @fields.each unless block

        @fields.each do |key,value|
          yield key, value
        end
      end

      def get key
        return @fields[key] if @fields.include? key

        # if we get here we dont have the value we should
        # get the cookie from the store and cache it's values
        fetch

        @fields[key]
      end

      def fetch
        @store.fetch(@key).each do |item, value|
          @fields[item] = value
        end
      end

      def set key, value
        @fields[key] = value
      end

      # Save the session in the store and return a key to it.
      def save
        @store.save @key, @fields
      end

    end

  end
end
