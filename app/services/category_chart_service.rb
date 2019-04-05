class CategoryChartService
  attr_accessor :category, :sub_categories, :month, :include_recurring

  def initialize(category:, month:, include_recurring:)
    self.category = category
    self.sub_categories = category.sub_categories.with_spending_for_month(
                            month, include_recurring: include_recurring
                          )
    self.month = month
    self.include_recurring = include_recurring
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

  def sub_categories_hash
    @_sub_categories_hash ||= generate_sub_categories_hash
  end

  def generate_sub_categories_hash
    hash = {}
    sorted_sub_categories.each { |sub_category| hash[sub_category.name] = sub_category.spending }
    hash
  end

  def last_six_months
    @_last_six_months ||= Array.new(6).each_with_index.map do |_, i|
      (month.to_date - i.month).strftime("%B %Y")
    end.reverse
  end

  def spending_history_data
    last_six_months.map do |month|
      category.transactions.by_month(month).yield_self { |transactions|
        include_recurring ? transactions.or(category.transactions.recurring) : transactions
      }.sum(:amount)
    end
  end

  def spending_history_labels
    last_six_months.map { |month| month.split(" ").first }
  end
end
