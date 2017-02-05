class User < ApplicationRecord
  has_many :books, dependent: :destroy

  validates :first_name, presence: true
end
