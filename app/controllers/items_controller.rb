class ItemsController < ApplicationController
	before_action :authenticate_with_token!

	# GET /lists/:list_id/items
  def index
		@items = Item.where(list: params[:list_id])
		render json: @items
  end
end
