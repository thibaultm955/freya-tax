class CreateCountryTaxCodes < ActiveRecord::Migration[6.0]
  def change
    create_table :country_tax_codes do |t|
      t.string :name
      t.float :rate

      t.timestamps
    end
  end
end
