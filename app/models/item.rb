class Item < ApplicationRecord
    belongs_to :entity
    belongs_to :tax_code_operation_rate
end
