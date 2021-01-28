class DueDate < ApplicationRecord
  belongs_to :project
  belongs_to :country
end
