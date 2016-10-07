class SessionsController < ApplicationController

	#POST /sessions
	def create
		user_password = params[:session][:password]
		user_email = params[:session][:email]
		user = user_email.present? && User.find_by(email: user_email)

		if user.valid_password? user_password
			sign_in user, store: false
			user.generate_authentication_token!
			user.save
			render json: user, status: :ok, location: user
		else
			render json: { errors: "Invalid email or password" }, status: :unprocessable_entity
		end
	end

	# DELETE /sessions/:id
	def destroy
		if user = User.find_by(auth_token: params[:id])
			user.generate_authentication_token!
			user.save
			head :no_content
		else
			render json: { errors: "User not found" }, status: :unprocessable_entity
		end
	end
end
