require "socket"
require 'json'

class Server
  clients = []
  TAG = "[Server]".freeze
  attr_reader :port

  def initialize
    begin
      #localhostの20000ポートに接続
      @port = TCPServer.open(20000)
      puts "#{TAG} TCPSocket.open success!"
    rescue
      puts "#{TAG} TCPSocket.open failed :#$!"
    end
  end

  def close
    @port.close
    puts "#{TAG} close"
  end

  # def send(msg)
  #   @port.send(msg)
  # end
  #
  # def receive
  #   p @port.gets
  # end
end

server = Server.new

# 通信受付開始
loop do
  socket = server.port.accept

  

  Thread.start(socket) do |client|
    loop do
      print socket.gets

    end
    client.close
  end
end

