class User < ActiveRecord::Base
  has_many:user_to_boards
  has_many:boards, :through => :user_to_boards
#  attr_accessible:board_ids

  def self.authenticate(email, password)
    user = self.where(email: email).first
    if self.encrypt_password(password) == user.password_hash
      return user
    else
      return nil
    end
  end

  def self.encrypt_password(password)
    salt = 'gerwg2$#H$"HRHAherwiahr$'
    if password.present?
      return Digest::MD5.hexdigest(password + salt)
    end
  end
end

