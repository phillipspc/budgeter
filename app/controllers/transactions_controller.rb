class TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_month

  def index
    @transactions = Transaction.includes(:category, :sub_category).
      where(created_at: @month.to_date..@month.to_date.end_of_month,
            user: @manager.group_users)

    @categories = @manager.categories.includes(:sub_categories, :transactions)

    @chart_service = ChartService.new(transactions: @transactions,
                                      categories: @categories,
                                      month: @month,
                                      manager: @manager)
  end

  def new
    @transaction = current_user.transactions.build
  end

  def create
    @transaction = current_user.transactions.build

    if @transaction.update_attributes(transaction_params)
      redirect_to transactions_path
    else
      render :new
    end
  end

  def edit
    @transaction = Transaction.find(params[:id])
  end

  def update
    @transaction = Transaction.find(params[:id])

    if @transaction.update_attributes(transaction_params)
      redirect_to transactions_path
    else
      render :new
    end
  end

  def destroy
    transaction = Transaction.find(params[:id])
    transaction.destroy!
    redirect_to transactions_path
  end

  private

    def set_month
      @month = params[:month] || Time.now.strftime("%B %Y")
    end

    def transaction_params
      params.require(:transaction).permit(:name, :amount, :date, :category_id, :sub_category_id)
    end
end
