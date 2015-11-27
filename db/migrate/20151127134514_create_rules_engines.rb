class CreateRulesEngines < ActiveRecord::Migration
  def change
    create_table :rules_engines do |t|
      t.string :name
      t.text :attribute
      t.string :operator
      t.string :value
      t.string :color

      t.timestamps null: false
    end
  end
end
