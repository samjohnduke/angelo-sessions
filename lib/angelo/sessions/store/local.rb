# TODO investegate implementing an expiring hash so that
# keys are removed if expired

module Angelo
  module Sessions
    class LocalStore < Store

      @@store = Hash.new

      def fetch id
        results = @@store[id] || Hash.new
      end

      def save id, fields
        return nil if fields.length <= 0
        id = id ? id : generate_id
        @@store[id] = fields
        id
      end

    end
  end
end
