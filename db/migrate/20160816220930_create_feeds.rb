class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.string :name, :null => false
      t.string :url, :null => false
      t.boolean :display, :default => true

      t.timestamps null: false
    end
  end
end
