class Invoice < ApplicationRecord
    has_many :transactions, dependent: :delete_all
    accepts_nested_attributes_for  :transactions
    belongs_to :entity
    belongs_to :customer
end
