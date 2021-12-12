class AddNameToCloudinaryPhoto < ActiveRecord::Migration[6.0]
  def change
    add_column :cloudinary_photos, :name, :string
  end
end
