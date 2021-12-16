class CreateUserAccessCompanies < ActiveRecord::Migration[6.0]
  def change
    create_table :user_access_companies do |t|
      t.references :company, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :access, null: false, foreign_key: true

      t.timestamps
    end
  end
end
