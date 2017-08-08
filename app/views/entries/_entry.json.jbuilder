json.extract! entry, :id, :subject, :link, :data, :read, :post_date, :feed_id, :created_at, :updated_at
json.url entry_url(entry, format: :json)