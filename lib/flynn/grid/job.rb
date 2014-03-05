module Flynn
  class Grid
    class Job < Struct.new(:id, :config, :host_config)
      def self.from_hash(hash)
        new *hash.values_at("ID", "Config", "HostConfig")
      end

      def env
        config["Env"].inject({}) do |hash, env|
          key, val = env.split("=")
          hash.merge key => val
        end
      end

      def volumes
        (config["Volumes"] || {}).inject({}) do |volumes, (vol, _)|
          bind = volume_binds.detect { |b| b =~ /:#{vol}:/ }

          if bind
            bind = bind.split(":").first
          end

          volumes.merge vol => bind
        end
      end

      private
      def volume_binds
        host_config["Binds"] || []
      end
    end
  end
end
