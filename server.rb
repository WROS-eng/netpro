require 'socket'
require 'json'
require './system.rb'

# サーバクラス
class Server

  attr_reader :port

  # サーバ初期化処理
  def initialize
    begin
      # 20000番のポートを解放
      @port = TCPServer.open(20000)
      puts 'TCPServer.open success!'
    rescue StandardError
      puts 'TCPServer.open failed :#$!'
    end
  end

  # サーバ切断処理
  # socket : 接続したソケットインスタンス
  def close(socket)
    socket.close
    puts 'close'
  end

  # サーバからの送信
  # socket : 接続したソケットインスタンス
  # msg : 送信メッセージ
  def send(socket, msg)
    socket.puts(msg)
  end

  # サーバへの送信
  # socket : 接続したソケットインスタンス
  def receive(socket)
    socket.gets.chomp
  end

  # ゲーム開始通知
  # socket : 接続したソケットインスタンス
  # turn : 手番
  # id : プレイヤーid
  # username : プレイヤー名
  # color : プレイヤーの使う色
  def notice_start_game(socket, turn_order, id, username, color)
    request = { turn_order: turn_order, id: id, username: username, color: color }
    send(socket, JSON.generate(request))
  end

  # 手番かどうかを通知する
  # socket : 接続したソケットインスタンス
  # turn_count : ターン数
  # is_play_turn : 手番かどうか
  def notice_play_turn(socket, turn_count, is_play_turn:, is_finish_game:)
    request = { turn_count: turn_count, is_play_turn: is_play_turn, is_finish_game: is_finish_game }
    send(socket, JSON.generate(request))
  end

  # ボード情報を通知する
  # socket : 接続したソケットインスタンス
  # username : ユーザー名
  # input_type : プレイヤーの行動
  # x, y : 置かれたx, y座標
  # color : 置かれた石の色
  # field_diff : 盤面の更新情報
  def notice_board_info(socket, username, input_type, x, y, color, field_diff)
    request = { username: username, input_type: input_type, x: x, y: y, color: color, field_diff: field_diff }
    send(socket, JSON.generate(request))
  end

  # プレイヤーが参加したとき
  # socket : 接続したソケットインスタンス
  # gc : ゲームコントローラインスタンス
  # return is_join : 参加に成功したか
  def on_join(socket, gc)
    begin
      # 受信
      request = receive(socket)
      p request

      # パース
      result = JSON.parse(request)

      # プレイヤー作成
      player = gc.register_player(result['username'])
      player.register_socket(socket)

      # 成功
      response = { status: 200, message: 'Succeeded join' }
      is_join = true
      return is_join
    rescue StandardError => e
      # 失敗
      response = { status: 500, message: 'Failed join', error: e.message }
      is_join = false
      return is_join
    ensure
      socket.puts(JSON.generate(response))
    end
  end

  # プレイヤーが指した時
  # socket : 接続したソケットインスタンス
  # gc : ゲームコントローラインスタンス
  # return is_play : 指すのに成功したか
  def on_play(socket, gc)
    begin
      # 受信
      request = receive(socket)
      p request

      # パース
      payload = JSON.parse(request)

      # プレイヤーの行動を反映
      input_type, x, y, color = payload['input_type'], payload['x'], payload['y'], payload['color']
      field_diff = []
      case input_type
        # 指した位置を反映
        when System::InputType::PUT then
          field_diff = gc.set_board_info(x, y, color)
        # # パスを記録
        when System::InputType::PASS then
          puts 'Pass'
        # ゲームを終了
        when System::InputType::RETIRE then
          puts 'Retire'
        else
          puts '未定義の行動です。'
      end

      # 成功
      response = { status: 200, message: 'Succeeded play' }
      is_play = true
      return is_play, input_type, x, y, color, field_diff
    rescue StandardError => e
      # 失敗
      response = { status: 600, message: 'Failed play', error: e.message }
      is_play = false
      return is_play, System::InputType::NONE, -1, -1, -9999, []
    ensure
      socket.puts(JSON.generate(response))
    end
  end
end
