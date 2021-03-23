class Return < ApplicationRecord
  belongs_to :periodicity_to_project_type
  belongs_to :country
  belongs_to :entity
  belongs_to :due_date
  has_many :transactions
end
