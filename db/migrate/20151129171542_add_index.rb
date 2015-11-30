class AddIndex < ActiveRecord::Migration
  def change
    add_index :rules_engines, :name
    add_index :rules_engines, :json_attribute
    add_index :application_detail, :uri
    add_index :application_detail, :name
  end
end
