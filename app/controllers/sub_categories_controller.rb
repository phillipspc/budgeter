class SubCategoriesController < ApplicationController
  def new
    @category = Category.find(params[:category_id])
    @sub_category = SubCategory.new
  end

  def create
    @category = Category.find(params[:category_id])
    @sub_category = @category.sub_categories.build
    unless @sub_category.update_attributes(sub_category_params)
      flash.now[:alert] = @sub_category.errors.full_messages.join(", ")
    end
  end

  private

    def sub_category_params
      params.require(:sub_category).permit(:name)
    end
end
