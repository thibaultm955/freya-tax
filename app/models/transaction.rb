class Transaction < ApplicationRecord
    belongs_to :return
    belongs_to :item
    belongs_to :invoice

end
