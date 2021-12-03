class CreateTypeTickets < ActiveRecord::Migration[6.0]
  def change
    create_table :type_tickets do |t|
      t.string :name
      t.references :language, null: false, foreign_key: true

      t.timestamps
    end
  end
end
