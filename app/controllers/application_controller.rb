class ApplicationController < ActionController::API
	include Pundit
	rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

	 def authenticate_with_token!
	 	@authentication = Authentication.new(request.headers["Authentication"])
    user_not_authorized unless user_signed_in?
  end

  private

  def user_signed_in?
  	@authentication.authenticated?
  end

  def current_user
    @current_user ||= @authentication.current_user
  end

  def user_not_authorized
    render json: { errors: "Permission denied" }, status: :unauthorized
  end
end
