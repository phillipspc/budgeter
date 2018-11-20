class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :category
  belongs_to :sub_category, optional: true

  validates_presence_of :name, :amount
end
