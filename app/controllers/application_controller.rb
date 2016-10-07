class ApplicationController < ActionController::API

	 def authenticate_with_token!
	 	@authentication = Authentication.new(request.headers["Authentication"])
    render json: { errors: "Not authenticated" },
										status: :unauthorized unless @authentication.authenticated?
  end
end
