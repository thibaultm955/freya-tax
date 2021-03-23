class Transaction < ApplicationRecord
    belongs_to :return
    belongs_to :entity_tax_code
end
