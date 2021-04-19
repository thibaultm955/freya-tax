class RemoveBoxNameToBoxInformationAndAddBoxNameId < ActiveRecord::Migration[6.0]
  def change
    remove_column :box_informations, :name
    add_reference :box_informations, :box_name, null: false, foreign_key: true
  end
end
