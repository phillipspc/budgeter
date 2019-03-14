class PlaidItem < ApplicationRecord
  belongs_to :user
  has_many :plaid_accounts, dependent: :destroy
  accepts_nested_attributes_for :plaid_accounts
end
