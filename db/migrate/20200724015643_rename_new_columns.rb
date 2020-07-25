class RenameNewColumns < ActiveRecord::Migration[6.0]
  def change
    rename_column :entries, :new_read, :read
    rename_column :entries, :new_pod, :pod
    rename_column :feeds, :new_display, :display
  end
end
