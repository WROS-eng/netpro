require './client.rb'

# クライアントの作成
client = Client.new

#送信内容の入力
client.join

# 開始通知の受付
client.on_game_start
