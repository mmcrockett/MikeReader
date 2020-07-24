class AddNewBoolean < ActiveRecord::Migration[6.0]
  def change
    add_column :feeds, :new_display, :boolean, default: true
    add_column :entries, :new_pod, :boolean, default: false
    add_column :entries, :new_read, :boolean, default: false
  end
end
