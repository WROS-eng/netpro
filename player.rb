# uuid生成に必要なモジュール
require "securerandom"

# プレイヤークラス
class Player
  attr_reader :id, :username, :color, :socket

  def initialize(username)
    @id = SecureRandom.uuid  # 識別id。名前だと被る恐れあるので、手番判定のときとかにこれを使う
    @username = username     # ユーザー名という名のプレイヤー名。
  end

  # ソケットインスタンスの登録
  # socket : クライアントソケットインスタンス
  def register_socket(socket)
    @socket = socket
  end

  # コマの色の登録
  # color : コマの色。
  def register_color(color)
    @color = color
  end
end
