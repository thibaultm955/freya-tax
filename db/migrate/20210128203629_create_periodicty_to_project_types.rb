class CreatePeriodictyToProjectTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :periodicty_to_project_types do |t|
      t.references :project_type, null: false, foreign_key: true
      t.references :periodicity, null: false, foreign_key: true

      t.timestamps
    end
  end
end
