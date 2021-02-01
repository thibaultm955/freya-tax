class PeriodicityToProjectType < ApplicationRecord
  belongs_to :project_type
  belongs_to :periodicity
  belongs_to :country
end
