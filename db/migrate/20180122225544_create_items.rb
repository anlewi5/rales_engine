class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      enable_extension("citext")
      
      t.citext :name
      t.string :description
      t.integer :unit_price
      t.references :merchant, foreign_key: true

      t.timestamps
    end
  end
end
