require "socket"
require 'json'
require "./client_player.rb"
require "./client_board.rb"

class Client
  TAG = "[Client]".freeze
  attr_reader :port, :client_player

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
  
  
  def on_noti_start_game
    begin 
      json = receive
      payload = JSON.parse(json)
      p payload
      p "色:#{payload["color"]} #{payload["username"]}さんは#{payload["turn_order"]}番です。"
      @client_player = ClientPlayer.new(payload["username"], payload["color"])
    rescue
      puts "回線が貧弱なので、通信に失敗したンゴ☺️ :#{__method__}"
    end
  end

  def on_noti_play_turn
    begin
      json = receive
      payload = JSON.parse(json)
      p "#{payload["turn_count"]}ターン目です。"
      return payload
    rescue
      puts "回線が貧弱なので、通信に失敗したンゴ☺️ :#{__method__}"
    end
   end

  def create_stone_pos_json(input_data,turn_type)
    json = ""
    case turn_type
    when 'RETIRE' 
      json = JSON.generate({input_type:"RETIRE"})
    when 'PASS'
      json = JSON.generate({input_type:"PASS"})
    when 'PUT'
      pos = input_data.chars
      json = JSON.generate({x:pos[0],y:pos[1],input_type:"PUT",color:client_player.color})
    else
      puts "不正な値が入っています:client.rb -> send_stone_pos"
    end
    return json
  end

  def on_noti_board_info
  end
  
  def join
    puts "プレイヤー名を入力してください"
    username = "player1"
    loop do
      username = gets.to_s.chomp
      break if username.length > 0
      puts "１文字以上で入力して下さい"
    end
    send(JSON.generate({username: username}))
    receive
  end


   def play(turn_data)
    if turn_data["is_play_turn"]
      puts "自分のターンです。置きたい場所を入力してください。"
      input = "xy"
      #ここに置けるかどうかの判定を入れる
      loop do
        input = gets.to_s.chomp
        #２文字、整数のみの判定 https://qiita.com/pecotech26/items/ee392125727f04bafaed
        if input.length == 2 && input =~ /^[0-9]+$/  
          json = create_stone_pos_json(input,"PUT")
          send(json)
          break 
        end
        #qが押されたら終了処理
        if input.eql?("q")
          json = create_stone_pos_json(input,"finishe")
          send(json)
          break 
        end
        puts "error"
      end 
    else
      puts "相手ターンです"
    end
  end
end