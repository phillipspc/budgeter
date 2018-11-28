class ChartService
  attr_accessor :transactions, :categories, :sub_categories, :month, :manager

  def initialize(transactions:, categories:, month:, manager:)
    self.transactions = transactions
    self.categories = categories
    self.sub_categories = SubCategory.where(category: categories)
    self.month = month
    self.manager = manager
  end

  def categories_data
    categories.map { |cat| cat.spending_for_month(month).to_i }.sort
  end

  def categories_labels
    categories.sort_by { |cat| cat.spending_for_month(month).to_i }.map(&:name)
  end

  def sub_categories_data
    sub_categories.map { |sub_cat| sub_cat.spending_for_month(month).to_i }.sort
  end

  def sub_categories_labels
    sub_categories.sort_by { |sub_cat| sub_cat.spending_for_month(month).to_i }.map(&:name)
  end

  def users_data
    manager.group_users.map { |user| user.spending_for_month(month).to_i }.sort
  end

  def users_labels
    manager.group_users.sort_by { |user| user.spending_for_month(month).to_i }.map(&:email)
  end
end
