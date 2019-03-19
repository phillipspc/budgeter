class IgnoredTransaction < ApplicationRecord
  belongs_to :user
  scope :by_month, -> (month) { where(date: month.to_datetime..month.to_datetime.end_of_month) }
end
