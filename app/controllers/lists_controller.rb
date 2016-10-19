class ListsController < ApplicationController
	before_action :authenticate_with_token!
	before_action :set_list, only: [:update, :destroy]

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

  # PATCH/PUT /lists/:id
  def update
    authorize @list, :update?

		if @list.update(list_params)
			render json: @list
		else
			render json: { errors: @list.errors }, status: :unprocessable_entity
		end
  end

  # DELETE /lists/:id
  def destroy
    authorize @list, :destroy?

  	if @list.destroy
  		head :no_content
  	else
  		render json: { errors: "cannot delete list" }, status: :unprocessable_entity
  	end
  end

  private

	def set_list
      @list = List.find(params[:id])
	end

	def list_params
		params.require(:list).permit(:title)
	end
end
