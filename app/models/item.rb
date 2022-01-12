class Item < ApplicationRecord
    belongs_to :entity
    belongs_to :tax_code_operation_type
    belongs_to :tax_code_operation_rate
    validates :item_name, :uniqueness => true


    def self.extract_amounts(quantity, item)
        net_amount = (quantity * item.net_amount).round(2)
        vat_amount = (quantity * item.vat_amount).round(2)

        return [quantity, net_amount, vat_amount]
    end

end
