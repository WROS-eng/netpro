require "socket"

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

client = Client.new

loop do
  #送信内容の入力
  puts "メッセージを入力してください"
  msg = gets.to_s
  client.send "#{msg}"
end
