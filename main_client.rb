# frozen_string_literal: true

require './client.rb'

# クライアントの作成
client = Client.new

# 送信内容の入力
client.join
puts "\n他の人が参加するまでお待ちください\n"

# 開始通知の受付
client.on_notice_start_game

# ゲームが終わったかどうかを判断する変数
is_finish_game = false

until is_finish_game

  puts "-----------"*5
  client.client_board.pretty_print

  _, is_play_turn, is_finish_game = client.on_notice_play_turn

  break if is_finish_game

  # 自分の番なら石を置く。相手ターンなら待つ
  if is_play_turn
    loop do
      puts "#{client.client_player.username}(#{client.client_player.mark} )のターンです。置きたい場所を入力してください。'posX,posY' or 'pass' or 'retire'　で入力してください"

      # 石を置く処理
      client.play#(true)

      # 200なら成功
      break if client.on_notice_play_response == 200

      puts '１文字以上で入力して下さい'
    end
  else
    puts '相手のターンです。'
    client.wait
  end

  # ボードのデータを受け取る
  client.on_notice_board_info
end

client.on_notice_result_data