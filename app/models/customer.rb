class Customer < ApplicationRecord
    belongs_to :country
    belongs_to :company
end
