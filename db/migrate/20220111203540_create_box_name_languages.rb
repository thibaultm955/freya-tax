class CreateBoxNameLanguages < ActiveRecord::Migration[6.0]
  def change
    create_table :box_name_languages do |t|
      t.references :box, null: false, foreign_key: true
      t.references :language, null: false, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
