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
    @transaction = @manager.transactions.build(name: plaid_transaction[:name],
                                               amount: plaid_transaction[:amount],
                                               date: plaid_transaction[:date],
                                               plaid_transaction_id: plaid_transaction[:transaction_id])

    matching_service = CategoryMatchingService.new(user: @manager,
                                                   category_data: plaid_transaction["category"]).run
    if matching_service.matched_plaid_category
      @category = matching_service.matched_plaid_category.category
      @sub_category = matching_service.matched_plaid_category.sub_category
    elsif matching_service.matched_sub_category
      @sub_category = matching_service.matched_sub_category
      @category = @sub_category.category
    elsif matching_service.matched_category
      @category = matching_service.matched_category
    end
  end

  def create
    @transaction = @manager.transactions.build

    if @transaction.update_attributes(transaction_params)
      flash.now[:notice] = "Successfully saved Transaction."
    else @transaction.errors.any?
      flash.now[:alert] = @transaction.errors.full_messages.join(", ")
      render partial: 'application/flash_messages', formats: [:js]
    end
  end

  def edit
    @transaction = @manager.transactions.find_by_plaid_transaction_id(params[:id])
  end

  def update
    @transaction = @manager.transactions.find_by_plaid_transaction_id(params[:id])
    @transaction.update_attributes(transaction_params)
    flash.now[:notice] = "Successfully updated Transaction"
  end

  def destroy
    @manager.transactions.find_by_plaid_transaction_id(params[:id]).destroy
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
