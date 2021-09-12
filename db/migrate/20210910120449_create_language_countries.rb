class CreateLanguageCountries < ActiveRecord::Migration[6.0]
  def change
    create_table :language_countries do |t|
      t.references :country
      t.references :language, null: false, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
