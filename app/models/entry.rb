class Entry < ActiveRecord::Base
  belongs_to :feed

  before_save :set_default_data

  serialize :data, JSON

  def exists?
    uri = URI::parse(self.link)
    search_path = "#{uri.path}"

    while (true == search_path.end_with?("/"))
      search_path.chop!
    end

    while ((true == search_path.start_with?("/")) && (0 < search_path.size))
      search_path = search_path[1..-1]
    end

    return Entry.exists?(['link LIKE ?', "%#{search_path}%"])
  end

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
