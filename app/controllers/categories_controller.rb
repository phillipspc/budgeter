class CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_category_and_confirm_ownership, only: [:edit, :update, :destroy]
  before_action :set_month, only: :show

  def index
    @categories = @manager.categories.includes(:sub_categories).order(:created_at)
  end

  def new
    @category = Category.new
    @url = categories_path
  end

  def create
    @category = Category.new
    unless @category.update_attributes(category_params.merge(user: @manager))
      flash.now[:alert] = @category.errors.full_messages.join(", ")
    end
  end

  def show
    @category = Category.includes(:sub_categories).find(params[:id])
    respond_to do |format|
      format.html do
        unless @category.user == @manager
          redirect_to categories_path, alert: "You do not have permission to access this page."
        end
        @transactions = @category.transactions.by_month(@month).order("date desc")
        @chart_service = CategoryChartService.new(category: @category, month: @month)
      end
      format.json do
        if @category.user == @manager
          render json: @category.sub_categories
        end
      end
    end
  end

  def edit
    @url = category_path(@category)
  end

  def update
    unless @category.update_attributes(category_params.merge(user: @manager))
      flash.now[:alert] = @category.errors.full_messages.join(", ")
    end
  end

  def destroy
    @category_id = @category.id
    unless @category.destroy
      flash.now[:alert] = "Unable to delete the requested Category"
    end
  end

  private

    def category_params
      params.require(:category).permit(:name)
    end

    def set_category_and_confirm_ownership
      @category = Category.find(params[:id])
      unless @category.user == @manager
        redirect_to categories_path, alert: "You do not have permission to access this page."
      end
    end
end
