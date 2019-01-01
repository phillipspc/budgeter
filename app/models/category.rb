class Category < ApplicationRecord
  belongs_to :user
  has_many :sub_categories, dependent: :destroy
  has_many :transactions

  validates_uniqueness_of :name, scope: :user_id

  validate :belongs_to_manager

  def sub_categories_with_spending_for_month(month)
    sub_categories.
      joins(
        <<-SQL.squish
          LEFT JOIN transactions ON
            transactions.sub_category_id = sub_categories.id AND
            transactions.date >= '#{month.to_date}' AND
            transactions.date <= '#{month.to_date.end_of_month}'
        SQL
      ).select(
        <<-SQL.squish
          sub_categories.name,
          sub_categories.id,
          sub_categories.budget,
          coalesce(SUM(DISTINCT transactions.amount), 0.0) AS spending
        SQL
      ).group("sub_categories.name, sub_categories.id, sub_categories.budget")
  end

  private

    def belongs_to_manager
      unless user.is_manager?
        errors.add(:user_id, "Is not a manager")
      end
    end
end
