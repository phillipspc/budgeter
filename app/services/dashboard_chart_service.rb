class DashboardChartService
  include ActionView::Helpers::NumberHelper
  attr_accessor :manager, :month, :include_recurring, :categories, :sub_categories

  def initialize(manager:, month:, include_recurring:)
    self.manager = manager
    self.month = month
    self.include_recurring = include_recurring
    self.categories = manager.categories.with_budget_and_spending_for_month(
                        month, include_recurring: include_recurring
                      )
    self.sub_categories = manager.sub_categories.with_spending_for_month(
                            month, include_recurring: include_recurring
                          )
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
      manager.transactions.by_month(month).yield_self { |transactions|
        include_recurring ? transactions.or(manager.transactions.recurring) : transactions
      }.sum(:amount)
    end
  end

  def spending_history_labels
    last_six_months.map { |month| month.split(" ").first }
  end
end
