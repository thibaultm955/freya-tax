class BoxLogic < ApplicationRecord
    belongs_to :amount
    belongs_to :tax_code_operation_location
    belongs_to :tax_code_operation_rate
    belongs_to :tax_code_operation_side
    belongs_to :tax_code_operation_type
end
