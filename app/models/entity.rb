class Entity < ApplicationRecord
  belongs_to :country
  belongs_to :company
  has_many :returns
  has_many :entity_tax_codes
end
