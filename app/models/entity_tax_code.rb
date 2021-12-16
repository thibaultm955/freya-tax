class EntityTaxCode < ApplicationRecord
  belongs_to :country_tax_code
  belongs_to :entity
  has_one :tax_code_operation_side, :through => :country_tax_code
  has_one :tax_code_operation_location, :through => :country_tax_code
  has_one :tax_code_operation_type, :through => :country_tax_code
  has_one :tax_code_operation_rate, :through => :country_tax_code
end
