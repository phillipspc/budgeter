class User < ApplicationRecord
  include Transactionable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable,
         :confirmable

  has_many :categories
  has_many :sub_categories, through: :categories
  has_many :transactions
  belongs_to :manager, class_name: "User", optional: true
  has_many :users, class_name: "User", foreign_key: "manager_id", inverse_of: :manager

  def group_users
    if is_manager?
      User.where(id: (users.pluck(:id) + [id]))
    else
      manager.group_users
    end
  end

  def categories_with_budget_and_spending_for_month(month)
    categories.
      joins(
        <<-SQL.squish
          LEFT JOIN transactions ON
            transactions.category_id = categories.id AND
            transactions.date >= '#{month.to_date}' AND
            transactions.date <= '#{month.to_date.end_of_month}'
        SQL
      ).select(
        <<-SQL.squish
          categories.name,
          categories.id,
          coalesce(SUM(transactions.amount), 0.0) AS spending
        SQL
      ).group("categories.name, categories.id")
  end
end
