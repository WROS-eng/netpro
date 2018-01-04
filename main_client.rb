require './client.rb'

# クライアントの作成
client = Client.new

#送信内容の入力
client.join

# 開始通知の受付
client.on_noti_start_game

#ゲームが終わったかどうかを判断する変数
is_finish_game = false

until is_finish_game do
    turn_count,is_play_turn,is_finish_game = client.on_noti_play_turn
    
    if is_finish_game
        break;
    end

    #自分の番なら石を置く。相手ターンなら待つ
    if is_play_turn then
        loop do
            puts "自分のターンです。置きたい場所を入力してください。"
            client.play()
            if client.on_noti_play_response == 200
                break
            end
            puts "１文字以上で入力して下さい"
        end
    else 
        puts "相手のターンです。"
        client.wait()
    end
    
    #ボードのデータを受け取る 
    client.on_noti_board_info   
end