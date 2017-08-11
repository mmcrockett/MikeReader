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
      entry.pod = true
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

  def self.articles
    return Entry.base_query.where(:pod => false)
  end

  def self.pods
    return Entry.base_query.where(:pod => true)
  end

  def self.base_query
    return Entry.where(:read => false).order(:post_date => :desc)
  end

  private
  def set_default_data
    self.data ||= {}
  end
end
