class PhpFeed < Feed
  self.table_name = "feed"

  def created_at
    return Date.strptime(self.date, "%Y%m%d")
  end

  def to_h
    return {
      name: self.name,
      url: self.url,
      display: true,
      created_at: self.created_at,
    }
  end
end

class PhpEntry < Entry
  self.table_name = "entry"

  def fixed_data
    if (true == self.data.is_a?(Hash))
      return self.data
    else
      return {}
    end
  end

  def post_date
    return Date.strptime(self.date, "%Y%m%d")
  end

  def to_h
    return {
      subject: self.subject.strip,
      link: self.link,
      data: fixed_data,
      read: false,
      pod: (false == fixed_data.empty?),
      post_date: self.post_date
    }
  end
end

class ConvertPhpData < ActiveRecord::Migration
  def change
    PhpFeed.where(:show => 1).each do |php_feed|
      entries = PhpEntry.where("feed_id = ? and read = 0", php_feed.id)
      feed    = Feed.new(php_feed.to_h)

      if (0 != entries.size)
        entries.each do |php_entry|
          feed.entries << Entry.new(php_entry.to_h)
        end
      end

      feed.save!
      feed.reload

      if (entries.size != feed.entries.size)
        raise "Missed some entries '#{entries.size}' '#{feed.entries.size}'."
      end
    end

    drop_table(PhpEntry.table_name)
    drop_table(PhpFeed.table_name)
  end
end
