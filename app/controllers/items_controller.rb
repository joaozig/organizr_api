class ItemsController < ApplicationController
	before_action :authenticate_with_token!
	before_action :set_item, only: [:update, :destroy]

	# GET /lists/:list_id/items
  def index
		@items = Item.where(list: params[:list_id])
		render json: @items
  end

  # POST /lists/:list_id/items
  def create
  	list = List.find(params[:list_id])
  	authorize list, :owner?

  	item = Item.new(item_params)
  	item.list = list

  	if item.save
  		render json: item, status: :created
  	else
  		render json: { errors: item.errors }, status: :unprocessable_entity
  	end
  end

  # PATCH/PUT /lists/:list_id/items/:id
  def update
		authorize @item, :update?

		if @item.update(item_params)
			render json: @item
		else
			render json: { errors: @item.errors }, status: :unprocessable_entity
		end
  end

  # DELETE /lists/:list_id/items/:id
  def destroy
  	authorize @item, :destroy?

  	if @item.destroy
  		head :no_content
  	else
  		render json: { errors: "cannot delete item" }, status: :unprocessable_entity
  	end
  end

  private

  def set_item
  	@item = Item.find(params[:id])
  end

	def item_params
		params.require(:item).permit(:title, :due_date)
	end
end
