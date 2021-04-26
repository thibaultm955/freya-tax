class CreateBoxInformations < ActiveRecord::Migration[6.0]
  def change
    create_table :box_informations do |t|
      t.string :name
      t.references :periodicity_to_project_type, null: false, foreign_key: true
      t.string :amount

      t.timestamps
    end
  end
end
