class AddCountryToPeriodicityToProjectType < ActiveRecord::Migration[6.0]
  def change
    add_reference :periodicty_to_project_types, :country, null: false, foreign_key: true
  end
end
