class AddCountryToDueDate < ActiveRecord::Migration[6.0]
  def change
    add_reference :due_dates, :country, null: false, foreign_key: true
  end
end
