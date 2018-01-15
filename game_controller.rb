require './player.rb'
require './server_board.rb'

# ゲームを管理するコントローラ
class GameController

  attr_reader :players, :curr_player

  # 初期化処理
  def initialize
    @turn = 0                          # ターン数
    @players = []                      # プレイヤーリスト
    @board = ServerBoard.new                 # 盤面
    @join_limit = ServerBoard::COLOR.length  # 参加上限数
    @curr_player = nil
  end

  # プレイヤーの登録
  # return : 登録プレイヤーインスタンス
  def register_player(username)
    player = Player.new(username)
    @players.push(player)
    return player
  end

  # 参加上限に達しているか
  def join_limit?
    @players.length >= @join_limit
  end

  # ゲームを開始させる
  # return : 手番マップ
  def start_game
    @turn = 1
    @players.shuffle!
    @players.each_with_index { |player, i| player.register_color(ServerBoard::COLOR.values[i]) }
    { first: @players[0], second: @players[1] }
  end

  # ゲームが終了したか
  # 終了条件
  #   プレイヤーがリタイアした
  #   パスが2回続いた
  #   置けなくなった
  def finished_game?
    @curr_player.retired? || @curr_player.streak_pass? || !@board.put_place_exist?(next_player.color)
  end

  # 指した位置を盤面に反映
  # x : x座標
  # y : y座標
  # color : コマの色
  # return クライアントに反映する石のリスト
  def set_board_info(x, y, color)
    return @board.put(x, y, color)
  end

  # その色の石の数を返す
  def get_stone_cnt(color)
    @board.get_stone_cnt(color)
  end

  # ターン開始時に呼ぶイベント処理
  # return ターン数, プレイするプレイヤー
  def on_turn_start
    player = turn_player
    if change_player?(player)
      @curr_player = player
      puts "#{@turn}ターン目"
    end
    return @turn, @curr_player
  end

  # ターン終了時に呼ぶイベント処理
  # is_play : 置くのに成功したか
  def on_turn_end(is_play)
    @turn += 1 if is_play
  end

  # 現在のターンプレイヤーを取得
  def turn_player
    @players[(@turn - 1) % @join_limit]
  end

  # 次のターンプレイヤーを取得
  def next_player
    @players[@turn % @join_limit]
  end

  # プレイヤーが変わっているか
  # player : プレイヤーインスタンス
  def change_player?(player)
    @curr_player.nil? || @curr_player.id != player.id
  end

  def result
    result = {}
    if @curr_player.retired? || @curr_player.streak_pass?
      result = @players.each{|p| [p.id, p.id==@curr_player.id ? 'lose' : 'win']}.to_h
    else
      data = @players.map{|p| [p.id, get_stone_cnt(p.color)]}.to_h
      if data.values.uniq.size > 1
        result = @players.map{|p| [p.id, p.id == data.max[0] ? 'win' : 'lose']}.to_h
      else
        result = @players.map{|p| [p.id, 'draw']}.to_h
      end
    end
    result
  end
end
