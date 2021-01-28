class CreateReturns < ActiveRecord::Migration[6.0]
  def change
    create_table :returns do |t|
      t.date :begin_date
      t.date :end_date
      t.references :project, null: false, foreign_key: true
      t.references :country, null: false, foreign_key: true
      t.references :entity, null: false, foreign_key: true
      t.references :due_date, null: false, foreign_key: true

      t.timestamps
    end
  end
end
