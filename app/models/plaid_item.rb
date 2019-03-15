class PlaidItem < ApplicationRecord
  belongs_to :user
  has_many :plaid_accounts, dependent: :destroy
  accepts_nested_attributes_for :plaid_accounts

  def account_ids_and_names
    {}.tap do |hash|
      plaid_accounts.each { |account| hash[account.account_id] = account.name }
      hash
    end
  end
end
