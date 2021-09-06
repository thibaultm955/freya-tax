class AddEmailAddressToEntity < ActiveRecord::Migration[6.0]
  def change
    add_column :entities, :email, :string
  end
end
