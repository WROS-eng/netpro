
# ゲームを管理するコントローラ
class GameController
  # 色のマップリスト。とりあえずゲームコントローラが持ってます
  COLOR = { white: -1, black: 1 }.freeze
  # 参加上限数
  JOIN_LIMIT = COLOR.length.freeze

  attr_reader :orders

  # 初期化処理
  def initialize
    @turn = 0     # ターン数
    @players = [] # プレイヤーリスト
    @orders = {}   # 手番マップ
  end

  # プレイヤーの登録
  def register_player(username)
    player = Player.new(username)
    @players.push(player)
    return player
  end

  # 参加上限に達しているか
  def is_join_limit?
    @players.length >= JOIN_LIMIT
  end

  # ゲームを開始させる
  # return : 手番マップ
  def start_game
    @turn = 1
    @players.shuffle!
    @players.each_with_index { |player, i| player.register_color(COLOR.values[i]) }
    @orders = {first: @players[0], second: @players[1] }
  end
end
