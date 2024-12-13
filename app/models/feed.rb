require 'rss'

class Feed < ApplicationRecord
  has_many :entries

  after_save :update_history

  def retrieve(file: nil)
    raise if file.present? && false == File.exist?(file)
    response = file.present? ? Struct.new(:code, :content_type, :body, :parsed_response).new(200, 'json', @f = File.read(file), @f) : HTTParty.get(self.url)

    if (200 == response.code)
      @feed = Struct.new(:feed_type, :json_data).new('json', response.parsed_response) if response.content_type.include?('json')

      @feed ||= RSS::Parser.parse(response.body, false)
    else
      raise "!ERROR: Unable to get '#{self.url}' '#{response}'."
    end

    return self
  end

  def origin
    @origin ||= URI.parse(self.url).origin
  end

  def atom?
    return ("atom" == @feed.feed_type)
  end

  def rss?
    return ("rss" == @feed.feed_type)
  end

  def json?
    return ("json" == @feed.feed_type)
  end

  def title
    if (true == self.rss?)
      return @feed.channel.title
    elsif (true == self.json?)
      return 'JSON'
    else
      return @feed.title.content()
    end
  end

  def process
    @published_dates = []

    if ((nil == name) || (true == name.empty?))
      self.name = self.title
    end

    items.each do |entry|
      new_entry = create_entry(entry)

      if (false == new_entry.exists?)
        @published_dates << (entry.try(:pubDate) || entry.try(:published).try(:content))
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
    elsif (true == self.json?)
      return @feed.json_data.dig('data', 'contentNodes', 'nodes')
    else
      return @feed.entries
    end
  end

  def create_entry(item)
    if (true == self.rss?)
      return Entry.from_rss(item)
    elsif (true == self.json?)
      return Entry.from_json(item)
    else
      return Entry.from_atom(item)
    end
  end

  def update_history
    History.create!(checked_at: Time.now)
  end
end
