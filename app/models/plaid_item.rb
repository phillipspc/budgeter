class PlaidItem < ApplicationRecord
  belongs_to :user
  has_many :plaid_accounts, dependent: :destroy
  has_many :plaid_imports, primary_key: :item_id
  accepts_nested_attributes_for :plaid_accounts

  def account_ids_and_names
    {}.tap do |hash|
      plaid_accounts.each { |account| hash[account.account_id] = account.name }
      hash
    end
  end

  def import_for_month(month)
    plaid_imports.find_by_month(month)
  end
end
