class PeriodicityToProjectType < ApplicationRecord
  belongs_to :project_type
  belongs_to :periodicity
  belongs_to :country
  has_one :due_date
end
