class Transaction < ApplicationRecord
    belongs_to :return
    belongs_to :entity_tax_code
    belongs_to :invoice
    has_one :item_transaction
end
