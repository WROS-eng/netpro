require 'socket'
require 'json'
require './system.rb'

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
  # socket : 接続したソケットインスタンス
  # turn : 手番
  # id : プレイヤーid
  # username : プレイヤー名
  # color : プレイヤーの使う色
  def noti_start_game(socket, turn_order, id, username, color)
    request = {turn_order: turn_order, id: id, username: username, color: color}
    socket.puts(JSON.generate(request))
  end

  # 手番かどうかを通知する
  # socket : 接続したソケットインスタンス
  # turn_count : ターン数
  # is_play_turn : 手番かどうか
  def noti_play_turn(socket, turn_count, is_play_turn:, is_finish_game:)
    request = {turn_count: turn_count, is_play_turn: is_play_turn, is_finish_game: is_finish_game}
    socket.puts(JSON.generate(request))
  end

  # ボード情報を通知する
  # socket : 接続したソケットインスタンス
  # board_info : ボード情報
  # input_type : プレイヤーの行動
  # x, y : 置かれたx, y座標
  # username : ユーザー名
  def noti_board_info(socket, board_info, username, input_type, x: -1, y: -1 )
    request = {board_info: board_info, username: username, input_type: input_type, x: x, y: y }
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
  # gc : ゲームコントローラインスタンス
  # return is_play : 指すのに成功したか
  def on_play(socket, gc)
    begin
      request = socket.gets.chomp
      puts request

      payload = JSON.parse(request)

      input_type, x, y = payload["input_type"], payload["x"], payload["y"]
      # プレイヤーの行動を反映
      case input_type
        # 指した位置を反映
        when System::InputType::PUT then
          gc.set_board_info(x, y, payload["color"])
        # # パスを記録
        # when System::InputType::PASS then
        # # ゲームを終了
        # when System::InputType::RETIRE then
        else
          puts "未定義の行動です。"
      end

      # 成功
      response = { status: 200, message: "Succeeded play" }
      is_play = true

    rescue => e
      # 失敗
      response = { status: 600, message: "Failed play", error: e.message }
      input_type, x, y = System::InputType::NONE, -1, -1
      is_play = false

    ensure
      socket.puts(JSON.generate(response))
      return is_play, input_type, x, y
    end
  end
end

