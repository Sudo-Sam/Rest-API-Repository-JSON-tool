class CreateApplicationDetails < ActiveRecord::Migration
  def change
    alter_table :application_detail do |t|
      t.string :name
      t.string :description  
      t.string :environment
      t.string :rest_method
      t.text :uri
      t.text :request_hdr
      t.text :request_text

      t.strings null:false
      t.texts null: false
      t.timestamps null: false
    end
  end
end
