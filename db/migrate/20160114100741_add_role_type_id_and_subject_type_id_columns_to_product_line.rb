class AddRoleTypeIdAndSubjectTypeIdColumnsToProductLine < ActiveRecord::Migration
  def change
    change_table :product_lines do |t|
      t.column :role_type_id, :integer, null: false, after: :dashboard_id
      t.column :subject_type_id, :integer, null: false, after: :role_type_id
    end
  end
end
