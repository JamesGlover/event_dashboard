class CreateDashboards < ActiveRecord::Migration
  def change
    create_table :dashboards do |t|
      t.string :key, limit: 20, null: false
      t.string :name, null: false
      t.string :password_digest, null: true

      t.timestamps null: false
    end
    add_index :dashboards, :key, unique: true
  end
end
