class SubCategoryChartService
  attr_accessor :sub_category, :month, :include_recurring

  def initialize(sub_category:, month:, include_recurring:)
    self.sub_category = sub_category
    self.month = month
    self.include_recurring = include_recurring
  end

  def last_six_months
    @_last_six_months ||= Array.new(6).each_with_index.map do |_, i|
      (month.to_date - i.month).strftime("%B %Y")
    end.reverse
  end

  def spending_history_data
    last_six_months.map do |month|
      sub_category.transactions.by_month(month).yield_self { |transactions|
        include_recurring ? transactions.or(sub_category.transactions.recurring) : transactions
      }.sum(:amount)
    end
  end

  def spending_history_labels
    last_six_months.map { |month| month.split(" ").first }
  end
end
