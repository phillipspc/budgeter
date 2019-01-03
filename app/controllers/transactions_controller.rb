class TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_month, only: :index

  def index
    @transactions = Transaction.includes(:user, :category, :sub_category).by_month(@month).
      where(user: @manager.group_users).
      order("date desc")

    @categories = @manager.categories_with_budget_and_spending_for_month(@month)
    @sub_categories = @manager.sub_categories_with_spending_for_month(@month)

    @chart_service = DashboardChartService.new(transactions: @transactions,
                                               categories: @categories,
                                               sub_categories: @sub_categories)
  end

  def new
    @transaction = current_user.transactions.build
    # keep track of redirect url so that we can go to the proper place after saving
    @redirect_url = params[:redirect_url]
    # if we're coming from a category page, we'll pre-select that category in the form
    @category = params[:category]
  end

  def create
    @transaction = current_user.transactions.build

    if @transaction.update_attributes(transaction_params)
      redirect_to params[:redirect_url], notice: "Successfully created Transaction"
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
      redirect_to params[:redirect_url], notice: "Successfully updated Transaction"
    else
      flash.now[:alert] = @transaction.errors.full_messages.join(", ")
      render partial: 'application/flash_messages', formats: [:js]
    end
  end

  def destroy
    transaction = Transaction.find(params[:id])
    transaction.destroy!
    redirect_to transactions_path
  end

  private

    def transaction_params
      params.require(:transaction).permit(:name, :amount, :date, :category_id, :sub_category_id, :recurring)
    end
end
