class AddCountryToBox < ActiveRecord::Migration[6.0]
  def change
    add_reference :boxes, :countries,  foreign_key: true
  end
end
