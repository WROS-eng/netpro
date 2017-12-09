require "socket"
require 'json'

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

  def noti_board_info(socket, board_info)
    request = {}
    player.socket.puts(JSON.generate(request))
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
  # gc : ゲームコントローラインスタンス
  # return is_play : 指すのに成功したか
  def on_play(socket, gc)
    begin
      request = socket.gets.chomp
      puts request

      payload = JSON.parse(request)

      # 指した位置を反映
      gc.write_board_info(payload["x"], payload["y"], payload["color"])

      # 成功
      response = { status: 200, message: "Succeeded play" }
      is_play = true

    rescue => e
      # 失敗
      response = { status: 600, message: "Failed play", error: e.message }
      is_play = false
    ensure
      socket.puts(JSON.generate(response))
      return is_play
    end
  end
end

