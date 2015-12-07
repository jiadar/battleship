# == Schema Information
#
# Table name: users
#
#  id            :integer          not null, primary key
#  username      :string           not null
#  password_hash :string           not null
#  session_token :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class User < ActiveRecord::Base
  validates :username, :password_hash, presence: true
  validates :username, uniqueness: true
  validates :password, length: { minimum: 6, allow_nil: true}

  attr_reader :password

  def reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64
    self.save!
    self.session_token
  end

  def password=(plaintext_pass)
    @password = plaintext_pass
    self.password_hash = BCrypt::Password.create(plaintext_pass)
  end

  def is_password?(plaintext_pass)
    BCrypt::Password.new(self.password_hash).is_password?(plaintext_pass)
  end

  def self.find_by_credentials(params)
    user = User.find_by(username: params[:username])
    return user if user && user.is_password?(params[:password])
    nil
  end

end
