class Feed < ActiveRecord::Base
  has_many :entries

  def retrieve
    response = HTTParty.get(self.url)

    if (200 == response.code)
      @feed = RSS::Parser.parse(response.body, false)
    else
      raise "!ERROR: Unable to get '#{self.url}' '#{response}'."
    end

    return self
  end

  def from_file(file)
    @feed = RSS::Parser.parse(File.read(file), false)
  end

  def atom?
    return ("atom" == @feed.feed_type)
  end

  def rss?
    return ("rss" == @feed.feed_type)
  end

  def title
    if (true == self.rss?)
      return @feed.channel.title
    else
      return @feed.title.content()
    end
  end

  def process
    if ((nil == name) || (true == name.empty?))
      self.name = self.title
    end

    items.each do |entry|
      new_entry = create_entry(entry)

      if (false == new_entry.exists?)
        self.entries << new_entry
      else
        Rails.logger.info("Already exists '#{new_entry.link}'.")
      end
    end

    return self
  end

  private
  def items
    if (true == self.rss?)
      return @feed.items
    else
      return @feed.entries
    end
  end

  def create_entry(item)
    if (true == self.rss?)
      return Entry.from_rss(item)
    else
      return Entry.from_atom(item)
    end
  end
end
