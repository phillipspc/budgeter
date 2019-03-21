class PlaidCategory < ApplicationRecord
  belongs_to :category
  belongs_to :sub_category, optional: true
end
