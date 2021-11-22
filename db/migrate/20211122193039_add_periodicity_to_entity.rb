class AddPeriodicityToEntity < ActiveRecord::Migration[6.0]
  def change
    add_reference :entities, :periodicity, foreign_key: true
  end
end
