require "socket"
require 'json'
require "./client_player.rb"
require "./client_board.rb"
require "./system.rb"

class Client
  TAG = "[Client]".freeze
  attr_reader :port, :client_player, :client_board

  def initialize()
    begin
      #localhostの20000ポートに接続
      @port = TCPSocket.open("localhost",20000)
      puts "#{TAG} TCPSocket.open success!"
    rescue
      puts "#{TAG} TCPSocket.open failed :#$!"
    end
  end

  def close
    @port.close
    puts "#{TAG} close"
  end

  def send(msg)
    @port.puts(msg)
  end

  def receive()
    p @port.gets
  end
  
  # ゲーム開始通知
  # turn : 手番
  # id : プレイヤーid
  # username : プレイヤー名
  # color : プレイヤーの使う色
  def on_noti_start_game
    #受信
    json = receive
    begin 
      #パース
      payload = JSON.parse(json)
      p payload

      #インスタンス生成
      @client_player = ClientPlayer.new(payload["username"], payload["color"])
      @client_board = ClientBoard.new()

      #orderのキャスト
      order = "先行"
      if payload["turn_order"] == "second"
        order = "後攻"
      end

      #ユーザーデータの表示
      puts "色:#{ClientBoard::COLOR.key(payload["color"])}"
      puts "#{payload["username"]}さんは#{order}です。"
      
      #盤面の描画
      @client_board.pretty_print
    
    rescue
      #失敗
      puts "回線が貧弱なので、通信に失敗したンゴ☺️ :#{__method__}"
      raise "回線エラー"

    end
  end

  # turn_count : ターン数
  # is_play_turn : 手番かどうか
  # is_finish_game : ゲームが終わったかどうか
  def on_noti_play_turn
    #受信
    json = receive
    
    begin
      #パース
      payload = JSON.parse(json)
      p "#{payload["turn_count"]}ターン目です。"
      
      #payloadの返却
      return payload["turn_count"],payload["is_play_turn"],payload["is_finish_game"]
   
    rescue
      #失敗
      puts "回線が貧弱なので、通信に失敗したンゴ☺️ :#{__method__}"
      raise "回線エラー"

    end
   end

  # ボード情報を受け取る
  # board_info : ボード情報
  # input_type : プレイヤーの行動
  # x, y : 置かれたx, y座標
  # username : ユーザー名
  def on_noti_board_info
    #受信
    json = receive
   
    begin
      #パース
      payload = JSON.parse(json)
      puts "#{payload}"
     
      #盤面の描画
      @client_board.update(payload["field_diff"], payload["color"])
      @client_board.pretty_print
      
    rescue
      #失敗
      puts "回線が貧弱なので、通信に失敗したンゴ☺️ :#{__method__}"
      raise "回線エラー"
    
    end
  end
  
  # username :ユーザー名
  def join
    puts "プレイヤー名を入力してください"
    username = "player1"
    
    #User名の入力
    loop do
      username = gets.to_s.chomp
      break if username.length > 0
      puts "１文字以上で入力して下さい"

    end
    
    #送信
    send(JSON.generate({username: username}))
    receive
  
  end

  # x : 置く位置X
  # y : 置く位置Y
  # input_type : PUT, PASS, RETIRE
  # color : playerのカラー(白 or 黒)
   def play()    
    #置く処理
    loop do
      input = gets.to_s.chomp
      #２文字、整数のみの判定 https://qiita.com/pecotech26/items/ee392125727f04bafaed
      if input =~ /^[1-8],\s?[1-8]$/
        #入力
        pos = input.split(",")
        
        #x、yにキャスト
        posX = pos[0].to_i
        posY = pos[1].to_i
        p " x = #{posX} y = #{posY}"

        if !@client_board.can_put_stone(posX,posY) then
          puts "そこは空きマスではないので、置けません"
          next
        end

        #裏返す石が一つ以上あるなら
        if @client_board.get_flip_count(client_player.color, posX, posY) > 0  
          #json生成
          json = create_stone_pos_json(posX, posY, System::InputType::PUT)
          
          #送信
          send(json)  
          break
        
        else
          #一つもない場合
          puts "そこは#{ClientBoard::FIELD[:blank]}ではないので置けません"
        end
      end

      #qが押されたら終了処理
      if input.eql?("q")
        #json生成
        json = JSON.generate({input_type:System::InputType::RETIRE})
        
        #送信
        send(json)
        break 
      
      end

      #qが押されたら終了処理
      if input.eql?("pass")
        #json生成
        json = JSON.generate({input_type:System::InputType::PASS})

        #送信
        send(json)
        break

      end
    end 
  end

  
  # playメソッド後、Serverから通信完了できたか、レスポンスが返ってくる
  # レスポンスのステータスをreturn
  # message : SuccessPlayなどのメッセージ
  # status  : 200なら成功
  def on_noti_play_response
    #受信
    json = receive

    begin
      #パース
      payload = JSON.parse(json)
      
      #成功
      puts "#{payload["message"]}"
      
      #statusをreturn
      return payload["status"]

    rescue
      #失敗　
      puts "回線が貧弱なので、通信に失敗したンゴ☺️ :#{__method__}"
      raise "回線エラー"
    
    end
  end

  def wait
  end

  # x : 置く位置X
  # y : 置く位置Y
  # input_type : PUT, PASS, RETIRE
  # color : playerのカラー(白 or 黒)
  def create_stone_pos_json(posX, posY, turn_type)
    json = ""
    
    #Json生成
    case turn_type
    when System::InputType::RETIRE
      json = JSON.generate({input_type:System::InputType::RETIRE})
    when System::InputType::PASS
      json = JSON.generate({input_type:System::InputType::PASS})
    when System::InputType::PUT
      json = JSON.generate({x:posX,y:posY, input_type:System::InputType::PUT, color:client_player.color})
    else
      #失敗
      p "不正な値が入っています:client.rb -> send_stone_pos"
      raise "stone_pos is incorrect value."
    end

    #jsonをreturn
    return json
  end
end