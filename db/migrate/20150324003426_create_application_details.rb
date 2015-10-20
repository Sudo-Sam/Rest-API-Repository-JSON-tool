class CreateApplicationDetails < ActiveRecord::Migration
  def change
    create_table :application_detail do |t|
      t.string :name
      t.string :environment
      t.string :rest_method
      t.text :uri
      t.text :request_hdr
      t.text :request_text

      t.timestamps null: false
    end
  end
end
