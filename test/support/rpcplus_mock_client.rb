require "yaml"

module RPCPlus
  class MockClient
    class << self
      attr_accessor :fixture_name, :client_class

      def enable
        self.client_class = RPCPlus.send(:remove_const, :Client)
        RPCPlus.send(:const_set, :Client, self)
      end

      def disable
        RPCPlus.send(:remove_const, :Client)
        RPCPlus.send(:const_set, :Client, client_class)
      end

      def commit
        responses = clients.map(&:responses).inject({}) do |responses, response|
          responses.merge response
        end

        unless responses.empty?
          File.open(fixture_path, "w") do |file|
            file.write YAML.dump(responses)
          end
        end
      end

      def new(*args)
        super.tap do |client|
          clients << client
        end
      end

      def clients
        @clients ||= []
      end

      def fixture_path
        "#{fixture_dir}/#{fixture_name}.yml"
      end

      def fixture_dir
        File.expand_path("../../fixtures", __FILE__)
      end
    end

    def initialize(host, port)
      @host = host
      @port = port
    end

    def request(method, arg)
      @cursors ||= Hash.new(0)
      cursor = @cursors[method]
      @cursors[method] += 1

      if fixture_exists?(method)
        if block_given?
          while response = fixture_response_for(method, cursor)
            yield response.value
          end
        else
          fixture_response_for(method, cursor)
        end
      else
        if block_given?
          client.request(method, arg) do |response|
            record(method, cursor, response)
            yield response
          end
        else
          response = client.request(method, arg).value
          record(method, cursor, response)
          Response.new response
        end
      end
    end

    def fixture_exists?(method)
      File.exists?(self.class.fixture_path) && fixture.has_key?(method)
    end

    def fixture_response_for(method, cursor)
      response = fixture[method][cursor].shift
      Response.new response if response
    end

    def fixture
      @fixture ||= YAML.load_file(self.class.fixture_path)
    end

    def record(method, cursor, response)
      responses[method][cursor] << response
    end

    def responses
      @responses ||= Hash.new { |h,k| h[k] = Hash.new { |h,k| h[k] = [] } }
    end

    def client
      @client ||= self.class.client_class.new(@host, @port)
    end
  end
end
