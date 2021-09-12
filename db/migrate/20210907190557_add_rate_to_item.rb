class AddRateToItem < ActiveRecord::Migration[6.0]
  def change
    add_reference :items, :tax_code_operation_rate,  foreign_key: true

  end
end
