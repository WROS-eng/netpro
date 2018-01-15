require './game_controller.rb'
require './server.rb'
require './system.rb'

# ゲームコントローラ作成
gc = GameController.new

# サーバ作成
server = Server.new

# 参加受付開始
until gc.join_limit?
  # 接続待機
  socket = server.port.accept

  # プレイヤー参加処理
  server.on_join(socket, gc)
end
puts '参加上限に達しました。'

# GameControllerへゲーム開始通知依頼
player_orders = gc.start_game

# 各プレイヤーへ開始通知
player_orders.each { |turn_order, p| server.notice_start_game(p.socket, turn_order, p.id, p.username, p.color) }

# ゲームが終わるまで手番ループ
is_finished = false
loop do
  # ターン開始
  turn_count, player = gc.on_turn_start

  # 各プレイヤーに手番かどうかを送る
  gc.players.each { |p| server.notice_play_turn(
      p.socket, turn_count,
      is_play_turn: (p.id == player.id),
      is_finish_game: is_finished,
      turn_player_name: gc.curr_player.username,
      turn_player_color: gc.curr_player.color,
      prev_play_action: gc.prev_player.last_log)
  }

  break if is_finished  # 結果送信処理実装したら外す

  # 指し指令受取
  is_play, input_type, x, y, color, field_diff = server.on_play(player.socket, gc)

  is_finished = gc.finished_game?

  # 各プレイヤーに盤面情報送信
  gc.players.each { |p| server.notice_board_info(p.socket, p.username, input_type, x, y, color, field_diff) }

  # ターン終了
  gc.on_turn_end(is_play)
end

# 各プレイヤーにゲーム結果送信
puts "終わり！"
battle_data = gc.result
results = gc.players.map{ |p| System::Result.new(p.username, battle_data[p.id], gc.get_stone_cnt(p.color), p.pass_cnt, p.color).to_h }
gc.players.each { |p| server.notice_result_data(p.socket, results) }
