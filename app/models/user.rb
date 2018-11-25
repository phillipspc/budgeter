class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable,
         :confirmable

  has_many :categories
  has_many :transactions
  belongs_to :manager, class_name: "User", optional: true
end
