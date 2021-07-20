class Transaction < ApplicationRecord
    belongs_to :return
    belongs_to :entity_tax_code
    belongs_to :invoice
    belongs_to :item
end
