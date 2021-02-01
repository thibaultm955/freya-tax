class RemoveCountryIdToDueDate < ActiveRecord::Migration[6.0]
  def change
    remove_column :due_dates, :country_id
  end
end
