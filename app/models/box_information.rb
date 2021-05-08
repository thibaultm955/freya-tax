class BoxInformation < ApplicationRecord
    belongs_to :box_name
    belongs_to :amount
    belongs_to :tax_code_operation_location
    belongs_to :tax_code_operation_rate
    belongs_to :tax_code_operation_side
    belongs_to :tax_code_operation_type
end
