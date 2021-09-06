class AddIbanBicToEntity < ActiveRecord::Migration[6.0]
  def change
    add_column :entities, :iban, :string
    add_column :entities, :bic, :string
  end
end
