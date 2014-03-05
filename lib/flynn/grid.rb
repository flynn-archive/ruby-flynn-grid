require "securerandom"
require "uri"

require "rpcplus"
require "discover"

require "flynn/grid/host"
require "flynn/grid/job"

module Flynn
  class Grid
    def hosts
      response = client.request("Cluster.ListHosts", {}).value

      response.values.map { |hash| Host.from_hash(hash) }
    end

    def jobs
      hosts.map(&:jobs).flatten
    end

    def schedule(image, options = {})
      job_id = "#{image}-#{SecureRandom.uuid}"

      config = {
        "Image"        => image,
        "Tty"          => false,
        "AttachStdin"  => false,
        "AttachStdout" => false,
        "AttachStderr" => false,
        "OpenStdin"    => false,
        "StdinOnce"    => false,
        "Env"          => format_env(options[:env] || {}),
        "Volumes"      => {}
      }

      host_config = {
        "Binds" => []
      }

      if options[:volumes]
        add_volumes(options[:volumes], config, host_config)
      end

      if filter = options[:on]
        hosts = self.hosts.select { |h| h.matches?(filter) }
      else
        hosts = self.hosts.take(1)
      end

      jobs = hosts.inject({}) do |jobs, host|
        jobs.merge host.id => [
          { "ID" => job_id, "Config" => config, "HostConfig" => host_config, "TCPPorts" => 1 }
        ]
      end

      client.request(
        "Cluster.AddJobs",
        "Incremental" => true,
        "HostJobs"    => jobs
      ).value
    end

    private
    def client
      # Memoize the client for each leader
      @clients ||= {}

      @clients[leader] ||= begin
        uri = URI.parse("tcp://#{leader.address}")
        RPCPlus::Client.new(uri.host, uri.port)
      end
    end

    def leader
      @service ||= discover.service("flynn-host")
      @service.leader
    end

    def discover
      @discover ||= Discover::Client.new
    end

    # Format env into an array of key=val strings
    def format_env(env = {})
      env.inject([]) do |env, (key, val)|
        env << "#{key}=#{val}"
      end
    end

    def add_volumes(volumes, config, host_config)
      volumes.each_pair do |volume, bind|
        config["Volumes"][volume] = {}

        if bind
          host_config["Binds"] << "#{bind}:#{volume}:rw"
        end
      end
    end
  end
end
