class Category < ApplicationRecord
  belongs_to :user
  has_many :sub_categories, dependent: :destroy
  has_many :plaid_categories, dependent: :destroy
  has_many :transactions

  validates_uniqueness_of :name, scope: :user_id

  validate :belongs_to_manager

  scope :with_budget_and_spending_for_month, -> (month, include_recurring: true) do
    joins(
      <<-SQL.squish
        LEFT JOIN transactions ON
          transactions.category_id = categories.id AND
          ((transactions.date >= '#{month.to_date}' AND transactions.date <= '#{month.to_date.end_of_month}')
          #{' OR transactions.recurring = true' if include_recurring})
      SQL
    ).joins(
      <<-SQL.squish
        LEFT JOIN (
          SELECT sub_categories.category_id, SUM(sub_categories.budget) AS total_budget
          FROM sub_categories
          GROUP BY sub_categories.category_id
        ) AS budgets_from_sub_categories ON budgets_from_sub_categories.category_id = categories.id
      SQL
    ).select(
      <<-SQL.squish
        categories.name,
        categories.id,
        coalesce(SUM(transactions.amount), 0.0) AS spending,
        coalesce(budgets_from_sub_categories.total_budget, 0.0) AS budget
      SQL
    ).group("categories.name, categories.id, budgets_from_sub_categories.total_budget")
  end

  private

    def belongs_to_manager
      unless user.is_manager?
        errors.add(:user_id, "Is not a manager")
      end
    end
end
