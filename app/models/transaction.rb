class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :category
  belongs_to :sub_category

  validates_presence_of :name, :amount
  validates_presence_of :date, unless: Proc.new { |transaction| transaction.recurring }
  validates_uniqueness_of :plaid_transaction_id, scope: :user_id, if: :plaid_transaction_id
  validates_inclusion_of :recurring, in: [false], if: :imported?

  scope :by_month, -> (month) { where(date: month.to_datetime..month.to_datetime.end_of_month) }
  scope :recurring, -> { where(recurring: true) }

  def imported?
    !!plaid_transaction_id
  end
end
