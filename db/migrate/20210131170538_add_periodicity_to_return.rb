class AddPeriodicityToReturn < ActiveRecord::Migration[6.0]
  def change
    add_reference :returns, :periodicity, null: false, foreign_key: true
  end
end
