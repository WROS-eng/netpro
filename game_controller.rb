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
  def finished_game?
    # プレイヤーがリタイアした、切断が切れた
    # パスが2回続いた
    # 置けなくなった
    false
  end

  # 指した位置を盤面に反映
  # x : x座標
  # y : y座標
  # color : コマの色
  # return クライアントに反映する石のリスト
  def set_board_info(x, y, color)
    return @board.put(x, y, color)
  end

  # ターン開始時に呼ぶイベント処理
  # return ターン数, プレイするプレイヤー, 置けるか
  def on_turn_start
    player = turn_player
    if change_player?(player)
      @curr_player = player
      puts "#{@turn}ターン目"
    end
    return @turn, @curr_player, @board.put_place_exist?
  end

  # ターン終了時に呼ぶイベント処理
  # is_play : 置くのに成功したか
  def on_turn_end(is_play)
    @turn += 1 if is_play
  end

  # ターンのプレイヤーを取得
  def turn_player
    @players[(@turn - 1) % @join_limit]
  end

  # プレイヤーが変わっているか
  # player : プレイヤーインスタンス
  def change_player?(player)
    @curr_player.nil? || @curr_player.id != player.id
  end
end
