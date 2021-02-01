class AddPeriodicityToProjectTypeToReturn < ActiveRecord::Migration[6.0]
  def change
    add_reference :returns, :periodicity_to_project_type, null: false, foreign_key: true
  end
end
