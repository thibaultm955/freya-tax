class AddLanguageToBoxName < ActiveRecord::Migration[6.0]
  def change
    add_column :box_names, :language, :string
  end
end
