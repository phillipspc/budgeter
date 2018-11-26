class Category < ApplicationRecord
  belongs_to :user
  has_many :sub_categories, dependent: :destroy
  has_many :transactions

  validates_uniqueness_of :name, scope: :user_id

  validate :belongs_to_manager

  def budget
    sub_categories.sum(:budget)
  end

  def transactions_for_month(month)
    transactions.where(created_at: month.to_date..month.to_date.end_of_month)
  end

  def spending_for_month(month)
    transactions_for_month(month).sum(:amount)
  end

  private

    def belongs_to_manager
      unless user.is_manager?
        errors.add(:user_id, "Is not a manager")
      end
    end
end
