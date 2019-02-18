class CreateSale < ActiveRecord::Migration[5.1]
  def change
    create_table :sales do |t|
      t.string :purchaser_name
      t.text :item_description
      t.float :item_price
      t.integer :purchase_count
      t.string :merchant_address
      t.string :merchant_name
      t.references :sale_file, foreign_key: true

      t.timestamps null: false
    end
  end
end