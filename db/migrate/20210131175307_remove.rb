class Remove < ActiveRecord::Migration[6.0]
  def change
    remove_column :returns, :periodicity_to_project_type_id
  end
end
