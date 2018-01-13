class ClientPlayer
  attr_reader :username, :color

  def initialize(username, color)
    @username = username
    @color = color
  end
end