class GridIntegrationTest < Minitest::Test
  def setup
    RPCPlus::MockClient.enable

    fixture_name = "#{self.class.name}-#{self.name}"
    RPCPlus::MockClient.fixture_name = fixture_name

    @grid = Flynn::Grid.new
  end

  def teardown
    RPCPlus::MockClient.commit unless error?
    RPCPlus::MockClient.disable
  end
end
