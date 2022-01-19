class RenameTableBoxName < ActiveRecord::Migration[6.0]
  def change
    rename_table :box_names, :boxes
  end
end
