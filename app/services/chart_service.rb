class ChartService
  attr_accessor :transactions, :categories, :sub_categories, :month, :manager

  def initialize(transactions:, categories:, sub_categories:, month:, manager:)
    self.transactions = transactions
    self.categories = categories
    self.sub_categories = sub_categories
    self.month = month
    self.manager = manager
  end

  def sorted_categories
    @_sorted_categories ||= categories.having("SUM(transactions.amount) > 0").order("spending DESC")
  end

  def categories_data
    @_categories_data ||= sorted_categories.map(&:spending)
  end

  def categories_labels
    @_categories_labels ||= sorted_categories.pluck(:name)
  end

  def largest_category
    @_largest_category ||= sorted_categories.first&.name
  end

  def sorted_sub_categories
    @_sorted_sub_categories ||= sub_categories.having("SUM(transactions.amount) > 0").order("spending DESC")
  end

  def sub_categories_data
    @_sub_categories_data ||= sorted_sub_categories.map(&:spending)
  end

  def sub_categories_labels
    @_sub_categories_labels ||= sorted_sub_categories.pluck(:name)
  end

  def largest_sub_category
    @_largest_sub_category ||= sorted_sub_categories.first&.name
  end

  def users_data
    manager.group_users.map { |user| user.spending_for_month(month).to_d }.sort
  end

  def users_labels
    manager.group_users.sort_by { |user| user.spending_for_month(month).to_d }.map(&:email)
  end
end
