class IgnoredTransaction < ApplicationRecord
  belongs_to :user
  scope :by_month, -> (month) { where(date: month.to_date..month.to_date.end_of_month) }
end
