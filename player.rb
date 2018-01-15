# uuid生成に必要なモジュール
require 'securerandom'

# プレイヤークラス
class Player
  attr_reader :id, :username, :color, :socket, :pass_cnt

  MAX_PASS = 2 # パス可能数

  LOG_LENGTH = 2 # ログの保存数

  def initialize(username)
    @id = SecureRandom.uuid  # 識別id。名前だと被る恐れあるので、手番判定のときとかにこれを使う
    @username = username     # ユーザー名という名のプレイヤー名。
    @pass_cnt = 0            # パス回数
    @play_log = []           # 行動ログ
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

  # 行動ログの保存
  def add_play_log(input_type)
    @play_log.push(input_type)
    @play_log.shift if @play_log.length > LOG_LENGTH
  end

  # 最後のログ取得
  def last_log
    @play_log.last
  end

  # 2連続でパスしたか
  def streak_pass?
    @play_log.last(2).count(System::InputType::PASS) == 2
  end

  # リタイアしたか
  def retired?
    last_log == System::InputType::RETIRE
  end
end
