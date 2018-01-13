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
until gc.finished_game?
  # ターン開始
  turn_count, player, = gc.on_turn_start

  # 各プレイヤーに手番かどうかを送る
  gc.players.each { |p| server.notice_play_turn(p.socket, turn_count, is_play_turn: (p.id == player.id), is_finish_game: false) }

  # 指し指令受取
  is_play, input_type, x, y, color, field_diff = server.on_play(player.socket, gc)

  # 各プレイヤーに盤面情報送信
  gc.players.each { |p| server.notice_board_info(p.socket, p.username, input_type, x, y, color, field_diff) }

  # ターン終了
  gc.on_turn_end(is_play)
end
