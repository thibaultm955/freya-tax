class Drop < ActiveRecord::Migration[6.0]
  def change
    drop_table :type_tickets
  end
end
