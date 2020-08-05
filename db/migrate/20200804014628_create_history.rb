class CreateHistory < ActiveRecord::Migration[6.0]
  def change
    create_table :histories do |t|
      t.datetime :checked_at
      t.datetime :last_article_at
    end
  end
end
