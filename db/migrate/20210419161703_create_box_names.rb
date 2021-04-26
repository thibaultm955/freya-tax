class CreateBoxNames < ActiveRecord::Migration[6.0]
  def change
    create_table :box_names do |t|
      t.string :name

      t.timestamps
    end
  end
end
