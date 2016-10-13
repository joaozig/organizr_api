class ApplicationController < ActionController::API

	 def authenticate_with_token!
	 	@authentication = Authentication.new(request.headers["Authentication"])
    render json: { errors: "Not authenticated" },
										status: :unauthorized unless user_signed_in?
  end

  def user_signed_in?
  	@authentication.authenticated?
  end
end
