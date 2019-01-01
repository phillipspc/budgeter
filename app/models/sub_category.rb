class SubCategory < ApplicationRecord
  belongs_to :category
  has_many :transactions

  validates_uniqueness_of :name, scope: :category_id
end
