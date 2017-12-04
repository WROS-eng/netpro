require "socket"
require 'json'
require './player.rb'

class Server
  # 参加上限数
  JOIN_LIMIT = 2.freeze
  # 色のマップリスト。とりあえずサーバが持ってます
  COLOR = { white: -1, black: 1 }.freeze

  attr_reader :port

  # サーバ初期化処理
  def initialize
    @players = []
    begin
      # 20000番のポートを解放
      @port = TCPServer.open(20000)
      puts "TCPServer.open success!"
    rescue
      puts "TCPServer.open failed :#$!"
    end
  end

  # サーバ切断処理
  def close
    @port.close
    puts "close"
  end

  # サーバからの送信
  # msg : 送信メッセージ
  def send(msg)
    @port.puts(msg)
  end

  # サーバへの送信
  def receive
    p @port.gets.chomp
  end

  # 参加上限に達しているか
  def is_join_limit?
    @players.length >= MAX_PLAYER
  end

  # プレイヤーが参加したとき
  # socket : 接続したソケットインスタンス
  # return is_join : 参加に成功したか
  def on_join(socket)
    begin
      # 受信
      request = socket.gets.chomp
      p request

      # パース
      result = JSON.parse(request)

      # プレイヤー作成
      color = @players.length == 0 ? COLOR[:white] : COLOR[:black]
      player = Player.new( result["username"], color )
      @players.push(player)

      # 成功
      response = { status: 200, id: player.id, username: player.username, color: player.color }
      is_join = true

    rescue => e
      # 失敗
      response = { status: 500, message: "Failed join", error: e.message }
      is_join = false

    ensure
      socket.puts(JSON.generate(response))
      return is_join
    end
  end

  # プレイヤーが指した時
  # def on_play(socket)
  #   request = socket.gets.chomp
  #   puts request
  #
  #   result = JSON.parse(request)
  #
  # end

end

# =============== ここから下にmain処理書く ===================

# サーバ作成
server = Server.new

# 通信受付開始
loop do
  if server.is_join_limit?
    puts "参加上限に達しました。"
    break
  end

  # 接続待機
  socket = server.port.accept

  # プレイヤー参加処理
  server.on_join(socket)

  # Thread.start(socket) do |client|
  #   loop do
  #     print socket.gets.chomp
  #
  #   end
  #   client.close
  # end
end

