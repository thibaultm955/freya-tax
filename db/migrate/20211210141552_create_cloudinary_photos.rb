class CreateCloudinaryPhotos < ActiveRecord::Migration[6.0]
  def change
    create_table :cloudinary_photos do |t|
      t.string :api_key
      t.references :invoice, null: false, foreign_key: true
      t.string :secure_url


      t.timestamps
    end
  end
end
