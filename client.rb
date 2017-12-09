require "socket"
require 'json'

class Client
  TAG = "[Client]".freeze
  attr_reader :port

  def initialize()
    begin
      #localhostの20000ポートに接続
      @port = TCPSocket.open("localhost",20000)
      puts "#{TAG} TCPSocket.open success!"
    rescue
      puts "#{TAG} TCPSocket.open failed :#$!"
    end
  end

  def close
    @port.close
    puts "#{TAG} close"
  end

  def send(msg)
    @port.puts(msg)
  end

  def receive()
    p @port.gets
  end


end