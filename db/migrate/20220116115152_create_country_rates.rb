class CreateCountryRates < ActiveRecord::Migration[6.0]
  def change
    create_table :country_rates do |t|
      t.references :country, null: false, foreign_key: true
      t.references :tax_code_operation_rate, null: false, foreign_key: true
      t.float :rate

      t.timestamps
    end
  end
end
