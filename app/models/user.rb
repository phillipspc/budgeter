class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable,
         :confirmable

  has_many :categories, dependent: :destroy
  has_many :sub_categories, through: :categories
  has_many :plaid_categories, through: :categories
  has_many :transactions, dependent: :destroy
  belongs_to :manager, class_name: "User", optional: true
  has_many :users, class_name: "User", foreign_key: "manager_id", inverse_of: :manager
  has_many :plaid_items, dependent: :destroy
  has_many :ignored_transactions, dependent: :destroy

  def group_users
    if is_manager?
      User.where(id: (users.pluck(:id) + [id]))
    else
      manager.group_users
    end
  end

  def can_import?
    plaid_items.any?
  end
end
