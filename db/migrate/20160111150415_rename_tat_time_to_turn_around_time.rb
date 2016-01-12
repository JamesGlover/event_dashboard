class RenameTatTimeToTurnAroundTime < ActiveRecord::Migration
  def change
    rename_column :product_line_event_types, :tat_time, :turn_around_time
  end
end
