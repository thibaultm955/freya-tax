class CreateEntityTaxCodes < ActiveRecord::Migration[6.0]
  def change
    create_table :entity_tax_codes do |t|
      t.string :name
      t.string :tax_code
      t.references :country_tax_code, null: false, foreign_key: true
      t.references :entity, null: false, foreign_key: true

      t.timestamps
    end
  end
end
