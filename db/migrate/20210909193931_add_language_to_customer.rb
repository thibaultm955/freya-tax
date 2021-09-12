class AddLanguageToCustomer < ActiveRecord::Migration[6.0]
  def change
    add_reference :countries, :language, foreign_key: true
  end
end
