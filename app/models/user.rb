class User < ApplicationRecord
  has_many :user_game_players
  has_many :games, :through => :user_game_players # maximum: 2 users

  validates :name, :login, :password, presence: true

  validates :login, uniqueness: true

  validates :password, length: { minimum: 5 }

  before_create :set_token

  def set_token
    self.token = SecureRandom.urlsafe_base64
  end

  def remove_token
    update(token: nil)
  end

  def valid_password?(pass)
    password.present? && password == pass
  end

  def json
    { id: id, name: name, login: login}
  end
end
