class DashboardChartService
  include ActionView::Helpers::NumberHelper
  attr_accessor :user, :transactions, :categories, :sub_categories, :month

  def initialize(user:, transactions:, categories:, sub_categories:, month:)
    self.user = user
    self.transactions = transactions
    self.categories = categories
    self.sub_categories = sub_categories
    self.month = month
  end

  def sorted_categories
    @_sorted_categories ||= categories.having("SUM(transactions.amount) > 0").order("spending DESC")
  end

  def categories_data
    sorted_categories.map(&:spending)
  end

  def categories_labels
    sorted_categories.pluck(:name)
  end

  def sorted_sub_categories
    @_sorted_sub_categories ||= sub_categories.having("SUM(transactions.amount) > 0").order("spending DESC")
  end

  def sub_categories_data
    sorted_sub_categories.map(&:spending)
  end

  def sub_categories_labels
    sorted_sub_categories.pluck(:name)
  end

  def last_six_months
    @_last_six_months ||= Array.new(6).each_with_index.map do |_, i|
      (month.to_date - i.month).strftime("%B %Y")
    end.reverse
  end

  def spending_history_data
    last_six_months.map do |month|
      user.transactions.by_month(month).or(user.transactions.recurring).sum(:amount)
    end
  end

  def spending_history_labels
    last_six_months.map { |month| month.split(" ").first }
  end
end
