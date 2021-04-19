class CreateAmounts < ActiveRecord::Migration[6.0]
  def change
    create_table :amounts do |t|

      t.timestamps
    end
  end
end
