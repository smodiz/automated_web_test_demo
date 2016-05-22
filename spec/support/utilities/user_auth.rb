class UserAuth
  def self.auth_token(user: ENV['QN_USER'])
    User.find_by(email: user).authentication_token
  end
end
