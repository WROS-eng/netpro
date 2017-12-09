require './server.rb'
require './player.rb'
require './game_controller.rb'

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
p orders

# 各プレイヤーへ開始通知
orders.map do |turn, player|
  server.noti_start_game(turn, player)
end

# ゲームが終わるまで手番ループ
# until gc.is_finished_game? do
#   gc.players.each do |player|
#     # ターン開始
#     gc.on_turn_start
#
#     # 指し指令受取待ち
#     on_play(player.socket)
#
#     # 盤面情報取得
#     board_info = gc.get_board_info
#
#     # 各プレイヤーに盤面情報送信
#     gc.players.each { |p| server.noti_board_info(p.socket, board_info) }
#
#     # ターン終了
#     gc.on_turn_end
#   end
# end