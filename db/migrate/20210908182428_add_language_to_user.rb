class AddLanguageToUser < ActiveRecord::Migration[6.0]
  def change
    add_reference :users, :language, foreign_key: true
  end
end
