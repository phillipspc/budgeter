class Plaid::CategoriesController < Plaid::BaseController
  before_action :set_client, only: :new

  def index
    @categories = @manager.plaid_categories
  end

  def new
    @category_data = @client.categories.get()['categories']
    @plaid_category = PlaidCategory.new
  end
end
