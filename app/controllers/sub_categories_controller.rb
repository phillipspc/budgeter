class SubCategoriesController < ApplicationController
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
    @transactions_including_recurring = @sub_category.transactions.by_month(@month).or(@sub_category.transactions.recurring)
    @chart_service = SubCategoryChartService.new(sub_category: @sub_category,
                                                 month: @month,
                                                 include_recurring: current_user.include_recurring)
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
    @sub_category = SubCategory.find_by_id(params[:id])
    @sub_category_id = @sub_category&.id
    @category = @sub_category&.category

    if @sub_category
      if @sub_category.transactions.any?
        render :destroy_modal
      else
        @sub_category.destroy
      end
    end
  end

  def update_transactions_and_destroy
    original_sub_category = @manager.sub_categories&.find_by_id(params[:id])
    new_category = @manager.categories&.find_by_id(params[:category_id])
    new_sub_category = new_category&.sub_categories&.find_by_id(params[:sub_category_id])

    if original_sub_category && new_category && new_sub_category
      # prevent re-assigning to same sub category
      if original_sub_category == new_sub_category
        redirect_to categories_path, alert: "You must select a new Sub Category to assign transactions to."
      else
        # update transactions to new category and sub category
        original_sub_category.transactions.
          update_all(category_id: new_category.id, sub_category_id: new_sub_category.id)

        @category = original_sub_category.category
        original_sub_category.destroy
        flash.now[:notice] = "Successfully updated Transactions and deleted Sub Category."
        render :destroy
      end
    else
      redirect_to categories_path, alert: "Unable to perform requested action."
    end
  end

  private

    def sub_category_params
      params.require(:sub_category).permit(:category_id, :name, :budget)
    end
end
