class TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_month, only: :index

  def index
    @transactions = @manager.transactions.includes(:user, :category, :sub_category).
                      by_month(@month).order("date desc")

    @categories = @manager.categories.with_budget_and_spending_for_month(@month)
    @sub_categories = @manager.sub_categories.with_spending_for_month(@month)

    @chart_service = DashboardChartService.new(manager: @manager,
                                               month: @month,
                                               include_recurring: current_user.include_recurring)
  end

  def recurring
    @transactions = @manager.transactions.recurring.includes(:user, :category, :sub_category).order("date desc")
  end

  def new
    @transaction = @manager.transactions.build
    # keep track of redirect url so that we can go to the proper place after saving
    @redirect_url = params[:redirect_url]
    # if we're coming from a category/sub_category page, we'll pre-select them in the form
    @category = Category.find_by_id(params[:category_id])
    @sub_category = SubCategory.find_by_id(params[:sub_category_id])
    @category = @sub_category.category if @sub_category && !@category
  end

  def create
    @transaction = @manager.transactions.build

    if @transaction.update_attributes(transaction_params)
      redirect_to @transaction.recurring? ? recurring_path : params[:redirect_url],
        notice: "Successfully created Transaction"
    else
      flash.now[:alert] = @transaction.errors.full_messages.join(", ")
      render partial: 'application/flash_messages', formats: [:js]
    end
  end

  def edit
    @transaction = Transaction.find(params[:id])
    # keep track of redirect url so that we can go to the proper place after saving
    @redirect_url = params[:redirect_url]
  end

  def update
    @transaction = Transaction.find(params[:id])

    if @transaction.update_attributes(transaction_params)
      redirect_to @transaction.recurring? ? recurring_path : params[:redirect_url],
        notice: "Successfully updated Transaction"
    else
      flash.now[:alert] = @transaction.errors.full_messages.join(", ")
      render partial: 'application/flash_messages', formats: [:js]
    end
  end

  def destroy
    transaction = Transaction.find(params[:id])
    transaction.destroy!
    redirect_to (params[:redirect_url] || transactions_path), notice: "Successfully deleted Transaction"
  end

  private

    def transaction_params
      params.require(:transaction).permit(:name, :amount, :date, :category_id, :sub_category_id, :recurring)
    end
end
