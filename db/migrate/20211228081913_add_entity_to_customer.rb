class AddEntityToCustomer < ActiveRecord::Migration[6.0]
  def change
    add_reference :customers, :entity, null: false, foreign_key: true, default: 2
    remove_column :customers, :company_id
  end
end
