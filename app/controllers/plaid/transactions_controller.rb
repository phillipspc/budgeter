class Plaid::TransactionsController < Plaid::BaseController
  before_action :set_client, only: :index
  before_action :set_month, only: :index
  before_action :ensure_plaid_items_present, only: :index
  before_action :restrict_future_months, only: :index

  def index
    importer = PlaidImporterService.new(month: @month, user: @manager)

    respond_to do |format|
      format.html { @items_and_data = importer.run }
      format.js do
        @items_and_data = importer.run(force_update: true)
        flash.now[:notice] = "Successfully synced Transaction data."
      end
    end
  end

  def new
    plaid_transaction = params[:plaid_transaction]
    @transaction = current_user.transactions.build(name: plaid_transaction[:name],
                                                   amount: plaid_transaction[:amount],
                                                   date: plaid_transaction[:date],
                                                   plaid_transaction_id: plaid_transaction[:transaction_id])

    category_query = plaid_transaction[:category].map do |category|
      "name ILIKE '%#{category}%'"
    end.join(" OR ")
    @category = @manager.categories.where(category_query).first
  end

  def create
    @transaction = current_user.transactions.build

    if @transaction.update_attributes(transaction_params)
      flash.now[:notice] = "Successfully saved Transaction."
    else @transaction.errors.any?
      flash.now[:alert] = @transaction.errors.full_messages.join(", ")
      render partial: 'application/flash_messages', formats: [:js]
    end
  end

  def edit
    @transaction = Transaction.where(plaid_transaction_id: params[:id], user: @manager.group_users).first
  end

  def update
    @transaction = Transaction.where(plaid_transaction_id: params[:id], user: @manager.group_users).first

    @transaction.update_attributes(transaction_params)
    flash.now[:notice] = "Successfully updated Transaction"
  end

  def destroy
    Transaction.where(plaid_transaction_id: params[:id], user: @manager.group_users).first.destroy
    @plaid_transaction_id = params[:id]
    flash.now[:notice] = "Successfully deleted Transaction"
  end

  private

    def transaction_params
      params.require(:transaction).permit(:plaid_transaction_id, :name, :amount, :category_id,
        :sub_category_id, :date)
    end

    def ensure_plaid_items_present
      unless @manager.can_import?
        redirect_to transactions_path, alert: "You have no accounts setup for importing transactions."
      end
    end

    def restrict_future_months
      if @month.to_date > Date.today.beginning_of_month
        redirect_to plaid_transactions_path, alert: "No import available for future months."
      end
    end
end
