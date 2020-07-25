class DropOldColumns < ActiveRecord::Migration[6.0]
  def change
    remove_column :entries, :read
    remove_column :entries, :pod
    remove_column :feeds, :display
  end
end
