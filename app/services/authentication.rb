class Authentication

	def initialize(auth_token)
		@auth_token = auth_token
	end

	def current_user
		@current_user ||= User.find_by(auth_token: @auth_token)
	end

  def authenticated?
  	current_user.present?
  end
end
