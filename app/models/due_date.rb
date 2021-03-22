class DueDate < ApplicationRecord
  belongs_to :periodicity_to_project_type
  validates :periodicity_to_project_type_id, :uniqueness => true
end
