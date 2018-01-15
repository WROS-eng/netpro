# frozen_string_literal: true

require 'socket'
require 'json'
require './client_player.rb'
require './client_board.rb'
require './system.rb'

class Client
  TAG = '[Client]'
  attr_reader :port, :client_player, :client_board

  def initialize
    begin
      # localhostの20000ポートに接続
      @port = TCPSocket.open('localhost', 20000)
      puts "#{TAG} TCPSocket.open success!"
    rescue StandardError
      puts "#{TAG} TCPSocket.open failed :#{$ERROR_INFO}"
      raise e.message
    end
  end

  def close
    @port.close
    puts "#{TAG} close"
  end

  def send(msg)
    @port.puts(msg)
  end

  def receive
    # p @port.gets
    @port.gets
  end

  # ゲーム開始通知
  # turn : 手番
  # id : プレイヤーid
  # username : プレイヤー名
  # color : プレイヤーの使う色
  def on_notice_start_game
    # 受信
    json = receive
    begin
      # パース
      payload = JSON.parse(json)
      # p payload

      # インスタンス生成
      @client_player = ClientPlayer.new(payload['username'], payload['color'])
      @client_board = ClientBoard.new

      # orderのキャスト
      order = '先行'
      order = '後攻' if payload['turn_order'] == 'second'

      # ユーザーデータの表示
      puts "色:#{ClientBoard::COLOR.key(payload['color'])}"
      puts "#{payload['username']}さんは#{order}です。"

      # 盤面の描画
      @client_board.pretty_print
    rescue StandardError
      # 失敗
      puts "回線が貧弱なので、通信に失敗したンゴ☺️ :#{__method__}"
      raise '回線エラー'
    end
  end

  # turn_count : ターン数
  # is_play_turn : 手番かどうか
  # is_finish_game : ゲームが終わったかどうか
  def on_notice_play_turn
    # 受信
    json = receive

    begin
      # パース
      payload = JSON.parse(json)
      puts "#{payload['turn_count']}ターン目です。"

      # payloadの返却
      return payload['turn_count'], payload['is_play_turn'], payload['is_finish_game']
    rescue StandardError
      # 失敗
      puts "回線が貧弱なので、通信に失敗したンゴ☺️ :#{__method__}"
      raise '回線エラー'
    end
   end

  # ボード情報を受け取る
  # board_info : ボード情報
  # input_type : プレイヤーの行動
  # x, y : 置かれたx, y座標
  # username : ユーザー名
  def on_notice_board_info
    # 受信
    json = receive

    begin
      # パース
      payload = JSON.parse(json)
      # puts payload.to_s

      # 盤面の描画
      @client_board.update(payload['field_diff'], payload['color'])
      @client_board.pretty_print
    rescue StandardError => e
      # 失敗
      puts "回線が貧弱なので、通信に失敗したンゴ☺️ :#{e.message}"
      raise '回線エラー'
    end
  end

  # username :ユーザー名
  def join
    puts 'プレイヤー名を入力してください'
    username = 'player1'

    # User名の入力
    loop do
      username = gets.to_s.chomp
      break unless username.empty?
      puts '１文字以上で入力して下さい'

    end

    # 送信
    send(JSON.generate(username: username))
    receive

  end

  # x : 置く位置X
  # y : 置く位置Y
  # input_type : PUT, PASS, RETIRE
  # color : playerのカラー(白 or 黒)
  # is_auto :　trueにしたら勝手に置いてくれます
  def play(is_auto = false)
    if is_auto then
      auto_play
      return
    end

    # 置く処理
    loop do
      # 入力
      input = gets.to_s.chomp.downcase
      # 入力文字がx,yの形
      if input =~ /^[1-8],\s?[1-8]$/
        # x、yにキャスト
        posX, posY = parse_input_to_pos(input)

        # 空きマスかどうか
        unless @client_board.can_put_stone(posX, posY)
          puts "そこは#{ClientBoard::MARK[:blank] }ではないので置けません"
          next
        end

        # 裏返す石が一つ以上あるなら
        if @client_board.get_flip_count(client_player.color, posX, posY) > 0
          # json生成
          json = JSON.generate(x: posX, y: posY, input_type: System::InputType::PUT, color: client_player.color)

          # 送信
          send(json)
          break
        else
          # 一つもない場合
          puts "そこは一つも裏返せないので置けません"
        end
      elsif input.eql?('retire')
        # リタイア
        # json生成
        json = JSON.generate(input_type: System::InputType::RETIRE)

        # 送信
        send(json)
        break
      elsif input.eql?('pass')
        # パス
        # json生成
        json = JSON.generate(input_type: System::InputType::PASS)

        # 送信
        send(json)
        break
      else
        # x,yでもpassでもretireでもない
        puts "無効な入力です。'posX,posY' or 'pass' or 'retire'　で入力してください"
      end
    end
  end

  def auto_play
    # 置く処理
    testX,testY = 1,1

    loop do
      # 入力
      # input = gets.to_s.chomp.downcase
      input = "#{testX},#{testY}"
      # 入力文字がx,yの形
      if input =~ /^[1-8],\s?[1-8]$/
        # x、yにキャスト
        posX, posY = parse_input_to_pos(input)

        # 空きマスかどうか
        unless @client_board.can_put_stone(posX, posY)
          puts "そこは#{ClientBoard::MARK[:blank]} ではないので置けません"
          testX +=1
          next
        end

        # 裏返す石が一つ以上あるなら
        if @client_board.get_flip_count(client_player.color, posX, posY) > 0
          # json生成
          json = JSON.generate(x: posX, y: posY, input_type: System::InputType::PUT, color: client_player.color)

          # 送信
          send(json)
          break
        else
          # 一つもない場合
          puts "そこは一つも裏返せないので置けません"
        end
      elsif input.eql?('retire')
        # リタイア
        # json生成
        json = JSON.generate(input_type: System::InputType::RETIRE)

        # 送信
        send(json)
        break
      elsif input.eql?('pass')
        # パス
        # json生成
        json = JSON.generate(input_type: System::InputType::PASS)

        # 送信
        send(json)
        break
      else
        # x,yでもpassでもretireでもない
        puts "無効な入力です。'posX,posY' or 'pass' or 'retire'　で入力してください"
      end

      testX +=1
      if testX >= ClientBoard::SQUARES then
        testX = 1
        testY += 1
        if(testY >= ClientBoard::SQUARES)then
          json = JSON.generate(input_type: System::InputType::PASS)
          send(json)
          break
        end
      end
    end
  end

  # playメソッド後、Serverから通信完了できたか、レスポンスが返ってくる
  # レスポンスのステータスをreturn
  # message : SuccessPlayなどのメッセージ
  # status  : 200なら成功
  def on_notice_play_response
    # 受信
    json = receive

    begin
      # パース
      payload = JSON.parse(json)

      # 成功
      puts (payload['message']).to_s

      # statusをreturn
      return payload['status']
    rescue StandardError
      # 失敗　
      puts "回線が貧弱なので、通信に失敗したンゴ☺️ :#{__method__}"
      raise '回線エラー'
    end
  end

  def wait; end

  # 入力された(posX,posY)のstrをパースする
  # input =　キーボード入力の(posX,posY)
  # return posX,posY
  def parse_input_to_pos(input)
    pos = input.split(',')
    posX, posY = pos[0].to_i, pos[1].to_i
  end

  def on_notice_result_data
    puts "終わり！"
    json = receive
    begin
      # パース
      payload = JSON.parse(json)
      # p payload

      results =  payload.map{|p| System::Result.new(*p.values)}
      # p results

      # 成功 出力
      puts "\n結果発表"

      results.each{|result|
        puts "#{BaseBoard::COLOR.key(result.color)} : #{result.stone_cnt} #{result.result}" }

      results
          .select{|result| result.result == 'win' }
          .each {|win_player| puts "#{win_player.username} win!"}

    rescue StandardError
    # 失敗　
      puts "回線が貧弱なので、通信に失敗したンゴ☺️ :#{__method__}"
      raise '回線エラー'
    end
  end
end
