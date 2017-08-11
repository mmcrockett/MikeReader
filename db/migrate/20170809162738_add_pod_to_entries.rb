class AddPodToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :pod, :boolean, default: false
  end
end
