class Company < ApplicationRecord
  belongs_to :country
  has_many :entities
end
