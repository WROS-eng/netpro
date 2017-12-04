# uuid生成に必要なモジュール
require "securerandom"

# プレイヤークラス
class Player
  attr_reader :id, :username, :color

  def initialize(username, color)
    @id = SecureRandom.uuid  # 識別id。名前だと被る恐れあるので、手番判定のときとかにこれを使う
    @username = username     # ユーザー名という名のプレイヤー名。
    @color = color           # コマの色。
  end
end
