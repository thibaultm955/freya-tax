class Country < ApplicationRecord
    has_many :country_tax_codes
    has_many :entities
    has_many :countries

    def self.location_is_the_same(entity, customer, european_countries)
        if entity.id == customer.id
            location = TaxCodeOperationLocation.where(name: "Domestic")[0]
        elsif european_countries.include?(@customer.country.id) 
            location = TaxCodeOperationLocation.where(name: "Intra-EU")[0]
        else
            location = TaxCodeOperationLocation.where(name: "Outside-EU")[0]
        end
        
        return location
    end
end
