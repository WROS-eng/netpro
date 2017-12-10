require "socket"
require 'json'

class Client
  TAG = "[Client]".freeze
  attr_reader :port, :player_client

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

  def join
    puts "プレイヤー名を入力してください"
    username = "player1"
    loop do
      username = gets.to_s.chomp
      break if username.length > 0
      puts "１文字以上で入力して下さい"
    end
    send(JSON.generate({username: username}))
    receive
  end

  def on_game_start
    json = receive
    payload = JSON.parse(json)
    p payload
    p "色:#{payload["color"]} #{payload["username"]}さんは#{payload["turn_order"]}番です。"
    #player_clientnの作成
    player_client = Player_Client.new(payload["username"]}, payload["color"])
  end

  
end