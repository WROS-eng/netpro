require "socket"
require 'json'
require './player.rb'
require './game_controller.rb'

class Server

  attr_reader :port

  # サーバ初期化処理
  def initialize
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

  # ゲーム開始通知
  # turn : 手番
  # player : プレイヤー情報
  def noti_start_game(turn, player)
    request = {turn: turn, id: player.id, username: player.username, color: player.color}
    player.socket.puts(JSON.generate(request))
  end

  # 盤面情報通知
  # socket : 接続したソケットインスタンス
  def noti_bord_info(socket)
    request = {}
    socket.puts(JSON.generate(request))
  end

  # プレイヤーが参加したとき
  # socket : 接続したソケットインスタンス
  # gc : ゲームコントローラインスタンス
  # return is_join : 参加に成功したか
  def on_join(socket, gc)
    begin
      # 受信
      request = socket.gets.chomp
      p request

      # パース
      result = JSON.parse(request)

      # プレイヤー作成
      player = gc.register_player(result["username"])
      player.register_socket(socket)

      # 成功
      response = { status: 200, message: "Succeeded join" }
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
  # socket : 接続したソケットインスタンス
  def on_play(socket)
    request = socket.gets.chomp
    puts request

    result = JSON.parse(request)

  end

end

# =============== ここから下にmain処理書く ===================

# ゲームコントローラ作成
gc = GameController.new

# サーバ作成
server = Server.new

# 参加受付開始
until gc.is_join_limit? do
  # 接続待機
  socket = server.port.accept

  # プレイヤー参加処理
  server.on_join(socket, gc)
end
puts "参加上限に達しました。"

# GameControllerへゲーム開始通知依頼
orders = gc.start_game

# 各プレイヤーへ開始通知
orders.map do |turn, player|
  server.noti_start_game(turn, player)
end

