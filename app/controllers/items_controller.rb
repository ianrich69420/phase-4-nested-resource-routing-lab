class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  def index
    if !params[:user_id]
      render json: Item.all, except: [:created_at, :updated_at], include: :user
    else
      render json: find_user.items, except: [:created_at, :updated_at]
    end
  end

  def show
    render json: Item.find(params[:id]), except: [:created_at, :updated_at]
  end

  def create
    user = find_user
    item = Item.create(item_params)
    user.items << item
    render json: item, except: [:created_at, :updated_at], status: :created
  end

  private

  def find_user
    User.find(params[:user_id])
  end

  def item_params
    params.permit(:name, :description, :price)
  end

  def render_not_found_response
    render json: { error: "User not found" }, status: :not_found
  end  
end
