class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string :subject, :null => false
      t.string :link, :null => false
      t.string :data, :null => false
      t.boolean :read, :default => false
      t.date :post_date, :null => false
      t.references :feed, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
