require './board.rb'

# ゲームを管理するコントローラ
class GameController

  attr_reader :players

  # 初期化処理
  def initialize
    @turn = 0                          # ターン数
    @players = []                      # プレイヤーリスト
    @board = Board.new                 # 盤面
    @join_limit = @board.COLOR.length  # 参加上限数
  end

  # プレイヤーの登録
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
    @players.each_with_index { |player, i| player.register_color(COLOR.values[i]) }
    {first: @players[0], second: @players[1] }
  end
end
