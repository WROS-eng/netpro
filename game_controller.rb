
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
  def register_player(username, socket)
    color = @players.length == 0 ? COLOR[:white] : COLOR[:black]
    player = Player.new( username, color, socket)
    @players.push(player)
    return player
  end

  # 参加上限に達しているか
  def is_join_limit?
    @players.length >= JOIN_LIMIT
  end

  # ゲームを開始させる
  def start_game
    @turn = 1
    @players.shuffle!
    @orders = {first: @players[0], second: @players[1] }
  end
end
