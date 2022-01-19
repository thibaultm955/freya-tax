class RenameBoxInformationToBoxLogic < ActiveRecord::Migration[6.0]
  def change
    rename_table :box_informations, :box_logics
  end
end
