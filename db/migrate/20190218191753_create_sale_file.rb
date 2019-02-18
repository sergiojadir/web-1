class CreateSaleFile < ActiveRecord::Migration[5.1]
  def change
    create_table :sale_files do |t|
      t.string :file_id
      t.string :file_filename
      t.string :file_size
      t.string :file_content_type

      t.timestamps null: false
    end
  end
end
