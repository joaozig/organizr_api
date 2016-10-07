class UsersController < ApplicationController

	# GET /users/:id
	def show
		@user = User.find(params[:id])
		render json: @user
	end

	# POST /users
	def create
		user = User.new(user_params)
		if user.save
			render json: user, status: :created, location: user
		else
			render json: { errors: user.errors }, status: :unprocessable_entity
		end
	end

	# PATCH/PUT /users/:id
	def update
		user = User.find(params[:id])
		if user.update(user_params)
			render json: user
		else
			render json: { errors: user.errors }, status: :unprocessable_entity
		end
	end

	private

		def user_params
			params.require(:user).permit(:email, :password, :password_confirmation)
		end
end
