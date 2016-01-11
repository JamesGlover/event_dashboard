class CreateProductLineEventTypes < ActiveRecord::Migration
  def change
    create_table :product_line_event_types do |t|
      t.integer :product_line_id, null: false
      t.integer :event_type_id, null: false
      t.integer :order, null: false
      t.integer :tat_time

      t.timestamps null: false
    end
    add_index :product_line_event_types, :product_line_id
  end
end
