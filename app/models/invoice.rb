class Invoice < ApplicationRecord
    has_many :transactions
    accepts_nested_attributes_for  :transactions
    belongs_to :entity
    belongs_to :customer
end
