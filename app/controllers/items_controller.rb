class ItemsController < ApplicationController
	before_action :authenticate_with_token!

	# GET /lists/:list_id/items
  def index
		@items = Item.where(list: params[:list_id])
		render json: @items
  end

  # POST /lists/:list_id/items
  def create
  	list = List.find(params[:list_id])

  	if list.user != @authentication.current_user
			user_not_authorized
  	else
	  	item = Item.new(item_params)
	  	item.list = list

	  	if item.save
	  		render json: item, status: :created
	  	else
	  		render json: { errors: item.errors }, status: :unprocessable_entity
	  	end
  	end
  end

  # PATCH/PUT /lists/:list_id/items/:id
  def update
		item = Item.find(params[:id])
		if item.list.user != @authentication.current_user
			user_not_authorized
		else
			if item.update(item_params)
				render json: item
			else
				render json: { errors: item.errors }, status: :unprocessable_entity
			end
		end
  end

  private

	def item_params
		params.require(:item).permit(:title, :due_date)
	end
end
