module Angelo
  module Sessions

    # Session bag will be the basic session accessor and in charge of parsing
    # and saving the session to the store as well as setting accessor id
    class Bag

      def initialize store, request
        if request.headers["Cookie"]
          
          cookies = request.headers["Cookie"].split(";").map do |c| 
            h = c.split('=')
            {:name => h[0].strip, :value => h[1].strip} 
          end

          cookie = _cookies.select do |c| 
            c[:name] == '__mayflower'
          end

          @key = cookie.first[:value] if cookie.length > 0

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
        load
        return @fields.each unless block

        @fields.each do |key,value|
          yield key, value
        end
      end

      def get key
        return @fields[key] if @fields.include? key

        # if we get here we dont have the value we should
        # get the cookie from the store and cache it's values
        load

        @fields[key]
      end

      def load
        @store.load(@key).each do |item, value|
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