# uuid生成に必要なモジュール
require 'securerandom'

# プレイヤークラス
class Player
  attr_reader :id, :username, :color, :socket

  MAX_PASS = 2  # パス可能数

  def initialize(username)
    @id = SecureRandom.uuid  # 識別id。名前だと被る恐れあるので、手番判定のときとかにこれを使う
    @username = username     # ユーザー名という名のプレイヤー名。
    @pass_cnt = 0
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

  # パス
  def pass
    can_pass = @pass_cnt < MAX_PASS
    @pass_cnt += 1 if can_pass
    return can_pass
  end

  # リタイア
  def retire

  end
end
