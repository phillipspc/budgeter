class SubCategory < ApplicationRecord
  belongs_to :category
  has_many :transactions

  validates_uniqueness_of :name, scope: :category_id

  scope :with_spending_for_month, -> (month) do
    joins(
      <<-SQL.squish
        LEFT JOIN transactions ON
          transactions.sub_category_id = sub_categories.id AND
          ((transactions.date >= '#{month.to_date}' AND transactions.date <= '#{month.to_date.end_of_month}') OR
           transactions.recurring = true)
      SQL
    ).select(
      <<-SQL.squish
        sub_categories.name,
        sub_categories.id,
        sub_categories.budget,
        coalesce(SUM(transactions.amount), 0.0) AS spending
      SQL
    ).group("sub_categories.name, sub_categories.id, sub_categories.budget")
  end
end
