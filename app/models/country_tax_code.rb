class CountryTaxCode < ApplicationRecord
    has_many :entity_tax_codes
    belongs_to :tax_code_operation_location
    belongs_to :tax_code_operation_rate
    belongs_to :tax_code_operation_side
    belongs_to :tax_code_operation_type
    belongs_to :tax_code_operation_type
    :country
end
