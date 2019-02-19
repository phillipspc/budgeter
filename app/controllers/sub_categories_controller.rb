class SubCategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_month, only: :show

  def new
    @category = Category.find(params[:category_id])
    @sub_category = @category.sub_categories.build
    @url = sub_categories_path(@sub_category)
  end

  def create
    @sub_category = SubCategory.new
    unless @sub_category.update_attributes(sub_category_params)
      flash.now[:alert] = @sub_category.errors.full_messages.join(", ")
    end
    @category = @sub_category.category
  end

  def show
    @sub_category = @manager.sub_categories.includes(:category).find_by_id(params[:id])

    unless @sub_category
      redirect_to categories_path, alert: "You do not have permission to access this page."
    end

    @transactions = @sub_category.transactions.by_month(@month).order("date desc")
    @chart_service = SubCategoryChartService.new(sub_category: @sub_category, month: @month)
  end

  def edit
    @sub_category = SubCategory.find(params[:id])
    @category = @sub_category.category
    @url = sub_category_path(@sub_category)
  end

  def update
    @sub_category = SubCategory.find_by_id(params[:id])
    @category = @sub_category.category
    unless @sub_category.update_attributes(sub_category_params)
      flash.now[:alert] = @sub_category.errors.full_messages.join(", ")
    end
  end

  def destroy
    sub_category = SubCategory.find_by_id(params[:id])
    @sub_category_id = sub_category&.id
    @category = sub_category&.category
    unless sub_category && sub_category.destroy
      flash.now[:alert] = "Unable to delete the requested Sub Category"
    end
  end

  private

    def sub_category_params
      params.require(:sub_category).permit(:category_id, :name, :budget)
    end
end
