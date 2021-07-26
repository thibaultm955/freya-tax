class AddCommentToTransaction < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :comment, :string
    remove_column :transactions, :item_id
  end
end
