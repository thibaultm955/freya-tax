class Country < ApplicationRecord
    has_many :country_tax_codes
    has_many :entities
end
