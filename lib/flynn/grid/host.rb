module Flynn
  class Grid
    class Host < Struct.new(:id, :jobs, :rules, :resources, :attributes)
      def self.from_hash(hash)
        new *hash.values_at("ID", "Jobs", "Rules", "Resources", "Attributes")
      end

      def jobs
        super.map { |hash| Job.from_hash(hash) }
      end
    end
  end
end
