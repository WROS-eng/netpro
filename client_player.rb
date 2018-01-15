# クライアント側で扱うプレイヤークラス
class ClientPlayer
  attr_reader :username, :color

  def initialize(username, color)
    @username = username
    @color = color
  end

  def mark
    ClientBoard::MARK[ClientBoard::COLOR.key(color)]
  end
end
