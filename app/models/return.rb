class Return < ApplicationRecord
  belongs_to :periodicity
  belongs_to :project_type
  belongs_to :country
  belongs_to :entity
  belongs_to :due_date
  has_many :transactions
  has_many :return_boxes
end
