class SubCategoriesController < ApplicationController
  def new
    @category = Category.find(params[:category_id])
    @sub_category = SubCategory.new
    @url = category_sub_categories_path(@category)
  end

  def create
    @category = Category.find(params[:category_id])
    @sub_category = @category.sub_categories.build
    unless @sub_category.update_attributes(sub_category_params)
      flash.now[:alert] = @sub_category.errors.full_messages.join(", ")
    end
  end

  def edit
    @category = Category.find(params[:category_id])
    @sub_category = SubCategory.find(params[:id])
    @url = category_sub_category_path(@category, @sub_category)
  end

  def update
    @category = Category.find(params[:category_id])
    @sub_category = @category.sub_categories.where(id: params[:id]).first
    unless @sub_category.update_attributes(sub_category_params)
      flash.now[:alert] = @sub_category.errors.full_messages.join(", ")
    end
  end

  def destroy
    category = Category.find(params[:category_id])
    sub_category = category.sub_categories.where(id: params[:id]).first
    @sub_category_id = sub_category&.id
    unless sub_category && sub_category.destroy
      flash.now[:alert] = "Unable to delete the requested Sub Category"
    end
  end

  private

    def sub_category_params
      params.require(:sub_category).permit(:name)
    end
end
