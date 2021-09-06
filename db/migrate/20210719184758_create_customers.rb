class CreateCustomers < ActiveRecord::Migration[6.0]
  def change
    create_table :customers do |t|
      t.string :name
      t.string :vat_number
      t.string :street
      t.string :city
      t.string :post_code
      t.string :country

      t.timestamps
    end
  end
end
