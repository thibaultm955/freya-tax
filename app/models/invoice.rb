class Invoice < ApplicationRecord
    has_many :transactions
    accepts_nested_attributes_for  :transactions
end
