class ChangeColumnName < ActiveRecord::Migration
  def change
    rename_column :rules_engines, :attribute, :json_attribute
  end
end
