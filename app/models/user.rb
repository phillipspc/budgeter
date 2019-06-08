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
  has_many :plaid_imports, through: :plaid_items
  has_many :ignored_transactions, dependent: :destroy

  alias_method :manager, :invited_by

  after_create :send_new_user_email

  scope :manager, -> { where('invited_by_id IS NULL') }
  scope :notifications_enabled, -> { where(notifications_enabled: true) }

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

  def has_linked_bank_account?
    plaid_items.any?
  end

  def safe_manager
    is_manager? ? self : manager
  end

  private

    def send_new_user_email
      NewUserMailer.with(user: self).send_email.deliver_now
    end
end
