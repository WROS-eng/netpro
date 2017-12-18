require './game_controller.rb'
require './server.rb'
require './system.rb'

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
orders.map {|turn_order, p| server.noti_start_game(p.socket, turn_order, p.id, p.username, p.color) }

#ゲームが終わるまで手番ループ
until gc.is_finished_game? do
  gc.players.each do |player|
    # ターン開始
    turn_count, _ = gc.on_turn_start

    # 各プレイヤーに手番かどうかを送る
    gc.players.each {|p| server.noti_play_turn(p.socket, turn_count, is_play_turn: (p.id == player.id), is_finish_game: false)}

    # 指し指令受取待ち
    is_play, input_type, x, y = server.on_play(player.socket, gc)

    # 盤面情報取得
    board_info = input_type == System::InputType::PUT ? gc.get_board_info : []

    # 各プレイヤーに盤面情報送信
    gc.players.each { |p| server.noti_board_info(p.socket, board_info, username: p.username, input_type: input_type, x: x, y: y) }

    # ターン終了
    gc.on_turn_end
  end
end