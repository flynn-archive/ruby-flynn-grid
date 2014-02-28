class TestFlynnHostServer < TestRPCServer
  PORT = 1113
  ID   = "abc"

  def self.start
    new(PORT).start
  end

  rpc_method "Cluster.ListHosts" do |client|
    client.send_response(
      ID => {
        "ID"   => ID,
        "Jobs" => [
          {
            "ID"          => "flynn-etcd-def321",
            "Container"   => "",
            "Attributes"  => nil,
            "Resources"   => nil,
            "TCPPorts"    => 2,
            "Config"      => {},
            "ContainerID" => "6e2dda89d80e0485718f551493a933263fcbb3115b8e62273fecc3a784e55851",
            "Status"      => 1,
            "StartedAt"   => "2014-02-26T04:53:54.47541391Z",
            "EndedAt"     => "0001-01-01T00:00:00Z",
            "ExitCode"    => 0,
            "Error"       => nil
          },
          {
            "ID"          => "flynn-discoverd-abc123",
            "Container"   => "",
            "Attributes"  => nil,
            "Resources"   => nil,
            "TCPPorts"    => 1,
            "Config"      => {},
            "ContainerID" => "20a773b0b49bf5f2b1f6ddc07db9a15cb53c1dcbb40cb3ef9f57772432d1471a",
            "Status"      => 1,
            "StartedAt"   => "2014-02-26T04:53:54.564168162Z",
            "EndedAt"     => "0001-01-01T00:00:00Z",
            "ExitCode"    => 0,
            "Error"       => nil
          }
        ],
        "Rules"      => nil,
        "Resources"  => { "memory" => { "value" => 1024, "overcommit" => false } },
        "Attributes" => nil
      }
    )
  end
end
