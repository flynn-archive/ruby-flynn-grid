class GridIntegrationTest < Minitest::Test
  def setup
    # If DISCOVERD is explicitly set, assume we are testing
    # against a real flynn-host so don't boot test servers
    unless ENV["DISCOVERD"]
      ENV["DISCOVERD"] = "127.0.0.1:#{TestDiscoverdServer::PORT}"
      TestFlynnHostServer.start
      TestDiscoverdServer.start
    end

    @grid = Flynn::Grid.new
  end
end
