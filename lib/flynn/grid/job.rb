module Flynn
  class Grid
    class Job < Struct.new(:id)
      def self.from_hash(hash)
        new hash["ID"]
      end
    end
  end
end
