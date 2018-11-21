class CategoriesController < ApplicationController
  def index
    @categories = Category.all.includes(:sub_categories).order(:created_at)
  end

  def new
    @category = Category.new
    @url = categories_path
  end

  def create
    @category = Category.new
    unless @category.update_attributes(category_params)
      flash.now[:alert] = @category.errors.full_messages.join(", ")
    end
  end

  def show
    @category = Category.find(params[:id])
    render json: @category.sub_categories
  end

  def edit
    @category = Category.find(params[:id])
    @url = category_path(@category)
  end

  def update
    @category = Category.find(params[:id])
    unless @category.update_attributes(category_params)
      flash.now[:alert] = @category.errors.full_messages.join(", ")
    end
  end

  def destroy
    category = Category.find(params[:id])
    @category_id = category.id
    unless category.destroy
      flash.now[:alert] = "Unable to delete the requested Category"
    end
  end

  private

    def category_params
      params.require(:category).permit(:name)
    end
end
