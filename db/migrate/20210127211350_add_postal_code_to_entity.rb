class AddPostalCodeToEntity < ActiveRecord::Migration[6.0]
  def change
    add_column :entities, :postal_code, :string
    add_column :entities, :city, :string
  end
end
