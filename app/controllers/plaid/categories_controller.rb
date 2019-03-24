class Plaid::CategoriesController < Plaid::BaseController
  before_action :set_client, only: [:new, :edit]
  before_action :set_category_data, only: [:new, :edit]

  def index
    @plaid_categories = @manager.plaid_categories.includes(:category, :sub_category).order(:hierarchy)
  end

  def new
    @plaid_category = PlaidCategory.new
  end

  def create
    @plaid_category = PlaidCategory.new(plaid_category_params)

    if @plaid_category.save
      redirect_to params[:redirect_url].presence || plaid_categories_path,
        notice: "Successfully created Category Mapping"
    else
      flash.now[:alert] = @plaid_category.errors.full_messages.join(", ")
      render partial: 'application/flash_messages', formats: [:js]
    end
  end

  def edit
    @plaid_category = PlaidCategory.find(params[:id])
    @redirect_url = params[:redirect_url] || plaid_categories_path
  end

  def update
    @plaid_category = PlaidCategory.find(params[:id])

    if @plaid_category.update_attributes(plaid_category_params)
      redirect_to params[:redirect_url].presence || plaid_categories_path,
        notice: "Successfully updated Category Mapping"
    else
      flash.now[:alert] = @plaid_category.errors.full_messages.join(", ")
      render partial: 'application/flash_messages', formats: [:js]
    end
  end

  def destroy
    PlaidCategory.find(params[:id]).destroy
    redirect_to plaid_categories_path, notice: "Successfully deleted Mapping"
  end


  private

    def plaid_category_params
      params.require(:plaid_category).permit(:hierarchy, :category_id, :sub_category_id)
    end

    def set_category_data
      @category_data = {}
      @client.categories.get()['categories'].each do |data|
        @category_data[data["category_id"]] = data["hierarchy"].join(", ")
      end
    end
end
