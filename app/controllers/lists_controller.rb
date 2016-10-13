class ListsController < ApplicationController
	before_action :authenticate_with_token!

	# GET /lists
  def index
  	render json: @authentication.current_user.lists
  end

  # POST /lists
  def create
  	list = List.new(list_params)
  	list.user = @authentication.current_user

  	if list.save
  		render json: list, status: :created
  	else
  		render json: { errors: list.errors }, status: :unprocessable_entity
  	end
  end

  private

  	def list_params
  		params.require(:list).permit(:title)
  	end
end
