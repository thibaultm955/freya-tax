class TaxCodeOperationType < ApplicationRecord
    validates :name, :uniqueness => true
    has_many :country_tax_codes

end
