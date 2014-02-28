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
      discover.service("flynn-host").leader
    end

    def discover
      @discover ||= Discover::Client.new
    end
  end
end
