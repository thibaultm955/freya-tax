class CreateDueDates < ActiveRecord::Migration[6.0]
  def change
    create_table :due_dates do |t|
      t.date :begin_date
      t.date :end_date
      t.date :due_date
      t.references :project, null: false, foreign_key: true
      t.references :country, null: false, foreign_key: true

      t.timestamps
    end
  end
end
