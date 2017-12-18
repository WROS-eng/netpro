require './player.rb'
require './server_board.rb'

# ゲームを管理するコントローラ
class GameController

  attr_reader :players

  # 初期化処理
  def initialize
    @turn = 0                          # ターン数
    @players = []                      # プレイヤーリスト
    @board = ServerBoard.new                 # 盤面
    @join_limit = ServerBoard::COLOR.length  # 参加上限数
  end

  # プレイヤーの登録
  # return : 登録プレイヤーインスタンス
  def register_player(username)
    player = Player.new(username)
    @players.push(player)
    return player
  end

  # 参加上限に達しているか
  def is_join_limit?
    @players.length >= @join_limit
  end

  # ゲームを開始させる
  # return : 手番マップ
  def start_game
    @turn = 1
    @players.shuffle!
    @players.each_with_index { |player, i| player.register_color(ServerBoard::COLOR.values[i]) }
    {first: @players[0], second: @players[1] }
  end

  # ゲームが終了したか
  def is_finished_game?
    # プレイヤーがリタイアした、切断が切れた
    # パスが2回続いた
    # 置けなくなった
    false
  end

  # 指した位置を盤面に反映
  # x : x座標
  # y : y座標
  # color : コマの色
  def set_board_info(x, y, color)
    @board.put(x, y, color)
  end

  # 盤面情報を取得
  def get_board_info

  end

  def on_turn_start
    puts "#{@turn}ターン目"
    # 置けるか確認
    can_put_stone = true
    return @turn, can_put_stone
  end

  def on_turn_end
    @turn += 1
  end
end
