class CreateProductLines < ActiveRecord::Migration
  def change
    create_table :product_lines do |t|
      t.string  :name, null: false
      t.integer :dashboard_id, null: false

      t.timestamps null: false
    end

    add_index :product_lines, :dashboard_id
  end
end
