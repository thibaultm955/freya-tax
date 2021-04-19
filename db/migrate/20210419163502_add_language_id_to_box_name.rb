class AddLanguageIdToBoxName < ActiveRecord::Migration[6.0]
  def change
    remove_column :box_names, :language
    add_reference :box_names, :language, null: false, foreign_key: true
  end
end
