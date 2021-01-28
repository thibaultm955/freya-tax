class EntityTaxCode < ApplicationRecord
  belongs_to :country_tax_code
  belongs_to :entity
end
