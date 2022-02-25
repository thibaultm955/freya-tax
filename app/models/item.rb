class Item < ApplicationRecord
    belongs_to :entity
    belongs_to :tax_code_operation_type
    belongs_to :tax_code_operation_rate
    validates :item_name, :uniqueness => true


    def self.extract_amounts(quantity, item, country_rate)
        net_amount = (quantity * item.net_amount).round(2)
        vat_amount = country_rate.rate / 100 * item.net_amount

        total_vat_amount = (quantity * vat_amount).round(2)

        return [quantity, net_amount, total_vat_amount]
    end

end
