class CategoryChartService
  attr_accessor :sub_categories

  def initialize(sub_categories:)
    self.sub_categories = sub_categories
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
end
