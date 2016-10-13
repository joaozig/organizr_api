class ListsController < ApplicationController
	before_action :authenticate_with_token!

	# GET /lists
  def index
  	render json: @authentication.current_user.lists
  end
end
