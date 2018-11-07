class TransactionsController < ApplicationController
  def index
    @transactions = Transaction.all
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

    def transaction_params
      params.require(:transaction).permit(:name, :amount, :date, :category_id, :sub_category_id)
    end
end
