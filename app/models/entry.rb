class Entry < ActiveRecord::Base
  belongs_to :feed

  before_save :set_default_data

  serialize :data, JSON

  def self.from_rss(rss)
    entry = Entry.new()
    entry.post_date = rss.pubDate
    entry.subject   = rss.title || rss.description
    entry.link      = rss.link || rss.enclosure.url

    if (nil != rss.enclosure)
      entry.data ||= {}
      entry.data[:length]  = "#{rss.itunes_duration}"[/\d+[:\d+]*/]
    end

    return entry
  end

  def self.from_atom(atom)
    entry = Entry.new()
    entry.post_date = atom.published.content
    entry.subject   = atom.title.content
    entry.link      = atom.link.href

    return entry
  end

  private
  def set_default_data
    self.data ||= {}
  end
end
