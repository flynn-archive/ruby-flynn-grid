require "celluloid/io"
require "yajl"

class TestRPCServer
  class Client
    attr_accessor :current_request

    def initialize(socket, rpc_methods)
      @socket      = socket
      @rpc_methods = rpc_methods

      @parser = Yajl::Parser.new
      @parser.on_parse_complete = method(:on_request_complete)
    end

    def process_requests
      @socket.readline # CONNECT /_goRPC_ HTTP/1.0\r\n
      @socket.readline # Accept: application/vnd.flynn.rpc-hijack+json\r\n
      @socket.readline # \r\n
      @socket.write "HTTP/1.0 200\r\nTestRPCServer at your service\r\n"

      while chunk = @socket.readpartial(512)
        @parser << chunk
      end
    end

    def on_request_complete(request)
      self.current_request = request

      rpc_method_for(request).call self
    end

    def send_response(result)
      response = {
        "id"     => self.current_request["id"],
        "result" => result
      }

      Yajl::Encoder.encode(response, @socket)
      @socket.write "\r\n"
    end

    def rpc_method_for(request)
      method = request["method"]

      @rpc_methods[method] || raise(%{no RPC method registered to handle "#{method}"})
    end
  end

  include Celluloid::IO

  class << self
    attr_reader :rpc_methods

    def rpc_method(method, &block)
      @rpc_methods ||= {}
      @rpc_methods[method] = block
    end
  end

  def initialize(port)
    @server = Celluloid::IO::TCPServer.new("127.0.0.1", port)
  end

  def start
    async.run
  end

  def run
    loop { async.handle_connection @server.accept }
  end

  def handle_connection(socket)
    Client.new(socket, self.class.rpc_methods).process_requests
  end
end
