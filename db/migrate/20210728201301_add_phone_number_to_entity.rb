class AddPhoneNumberToEntity < ActiveRecord::Migration[6.0]
  def change
    add_column :entities, :phone_number, :string
  end
end
