class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :category
  belongs_to :sub_category

  validates_presence_of :name, :amount, :category_id
  validates_presence_of :date, unless: Proc.new { |transaction| transaction.recurring }
  validates_uniqueness_of :plaid_transaction_id, scope: :user_id, if: :plaid_transaction_id
  validates_inclusion_of :recurring, in: [false], if: :imported?

  scope :by_month, -> (month) { where(date: month.to_date..month.to_date.end_of_month) }
  scope :recurring, -> { where(recurring: true) }

  def imported?
    !!plaid_transaction_id
  end

  def plaid_import
    user.plaid_imports.where(
      "data::jsonb @> ?", [{ transaction_id: plaid_transaction_id }].to_json
    ).first if plaid_transaction_id
  end
end
