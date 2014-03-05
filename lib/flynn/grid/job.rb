module Flynn
  class Grid
    class Job < Struct.new(:id, :config)
      def self.from_hash(hash)
        new *hash.values_at("ID", "Config")
      end

      def env
        config["Env"].inject({}) do |hash, env|
          key, val = env.split("=")
          hash.merge key => val
        end
      end
    end
  end
end
