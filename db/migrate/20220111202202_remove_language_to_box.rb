class RemoveLanguageToBox < ActiveRecord::Migration[6.0]
  def change
    remove_column :boxes, :language_id
  end
end
