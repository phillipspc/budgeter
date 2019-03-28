class User < ApplicationRecord
  devise :invitable, :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable,
         :confirmable

  has_many :categories, dependent: :destroy
  has_many :sub_categories, through: :categories
  has_many :plaid_categories, through: :categories
  has_many :transactions, dependent: :destroy
  belongs_to :manager, class_name: "User", optional: true, foreign_key: "invited_by_id"
  has_many :users, class_name: "User", foreign_key: "invited_by_id", inverse_of: :manager
  has_many :plaid_items, dependent: :destroy
  has_many :ignored_transactions, dependent: :destroy

  alias_method :manager, :invited_by

  def is_manager?
    manager.nil?
  end

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
