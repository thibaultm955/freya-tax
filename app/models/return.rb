class Return < ApplicationRecord
  belongs_to :project
  belongs_to :country
  belongs_to :entity
  belongs_to :due_date
end
