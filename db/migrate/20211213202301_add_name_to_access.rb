class AddNameToAccess < ActiveRecord::Migration[6.0]
  def change
    add_column :accesses, :name, :string
    remove_column :accesses, :CreateAccesses

  end
end
