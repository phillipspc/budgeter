class Category < ApplicationRecord
  include Transactionable
  belongs_to :user
  has_many :sub_categories, dependent: :destroy
  has_many :transactions

  validates_uniqueness_of :name, scope: :user_id

  validate :belongs_to_manager

  def budget
    sub_categories.sum(:budget)
  end

  private

    def belongs_to_manager
      unless user.is_manager?
        errors.add(:user_id, "Is not a manager")
      end
    end
end
