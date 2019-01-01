class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :category
  belongs_to :sub_category

  validates_presence_of :name, :amount

  scope :by_month, -> (month) { where(created_at: month.to_datetime..month.to_datetime.end_of_month) }
end
