class Project < ApplicationRecord
  belongs_to :country
  has_many :transactions
end
