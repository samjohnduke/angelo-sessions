# TODO investegate implementing an expiring hash so that
# keys are removed if expired

module Angelo
  module Sessions
    class LocalStore < Store

      @@store = Hash.new

      def load id
        results = @@store[id]
      end

      def save id, fields
        return nil if fields.length <= 0
        id = key ? key : generate_id
        @@store[id] = fields
        id
      end

    end
  end
end