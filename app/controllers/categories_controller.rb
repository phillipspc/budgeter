class CategoriesController < ApplicationController
  def index
    @categories = Category.all.includes(:sub_categories)
  end

  def new
  end

  def create
  end
end
