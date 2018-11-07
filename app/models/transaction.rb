class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :category
  belongs_to :sub_category, optional: true
end
