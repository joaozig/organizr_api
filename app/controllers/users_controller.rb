class UsersController < ApplicationController
	before_action :set_user, only: [:show, :update, :destroy]

	# GET /users/:id
	def show
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
		if @user.update(user_params)
			render json: @user
		else
			render json: { errors: @user.errors }, status: :unprocessable_entity
		end
	end

	# DELETE /users/:id
	def destroy
		@user.destroy

		head :no_content
	end

	private

		def set_user
			@user = User.find(params[:id])
		end

		def user_params
			params.require(:user).permit(:email, :password, :password_confirmation)
		end
end
