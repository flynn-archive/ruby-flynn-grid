class TestDiscoverdServer < TestRPCServer
  PORT = 1111

  def self.start
    new(PORT).start
  end

  rpc_method "Agent.Subscribe" do |client|
    client.send_response(
      "Addr"    => "127.0.0.1:#{TestFlynnHostServer::PORT}",
      "Attrs"   => { "id" => TestFlynnHostServer::ID },
      "Created" => 0,
      "Name"    => "flynn-host",
      "Online"  => true
    )

    client.send_response(
      "Addr"    => "",
      "Name"    => ""
    )
  end
end
