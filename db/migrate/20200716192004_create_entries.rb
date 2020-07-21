class CreateEntries < ActiveRecord::Migration[6.0]
  def change
    create_table :entries do |t|
      t.string :subject, null: false
      t.string :link, null: false
      t.text :data, null: false
      t.date :post_date, null: false
      t.boolean :pod, default: false
      t.boolean :read, default: false
      t.references :feed, null: false, foreign_key: true

      t.timestamps
    end
  end
end
