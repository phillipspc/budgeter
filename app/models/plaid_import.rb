class PlaidImport < ApplicationRecord
  belongs_to :plaid_item, primary_key: :item_id
end
