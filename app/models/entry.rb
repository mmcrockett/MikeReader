class Entry < ActiveRecord::Base
  belongs_to :feed

  before_save :set_default_data

  serialize :data, JSON

  MAX_COMPOUND_SUBJECT_SIZE = 120
  MIN_COMPOUND_SUBJECT_WORD_COUNT = 5
  MIN_COMPOUND_SUBJECT_SIZE = 30
  LONG_WORD_SIZE            = 12

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
    entry.set_subject(rss.title, rss.description)
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

  def set_subject(title, description)
    description ||= ""
    self.subject = "#{title}"

    if ((MIN_COMPOUND_SUBJECT_SIZE > self.subject.size) && (MIN_COMPOUND_SUBJECT_WORD_COUNT > self.subject.split(' ').size))
      words = description.split(' ')
      first = true

      while ((false == words.empty?) && (MAX_COMPOUND_SUBJECT_SIZE > self.subject.size))
        word = words.shift

        if (true == first)
          if (false == self.subject.empty?)
            self.subject << ":"
          end

          first = false
        end

        if ((MAX_COMPOUND_SUBJECT_SIZE < (word.size + self.subject.size)) && (LONG_WORD_SIZE < word.size))
          word = word[0..MAX_COMPOUND_SUBJECT_SIZE - self.subject.size]
        end

        self.subject << " #{word}"
      end
    end

    if (true == self.subject.empty?)
      self.subject = "nil Title and nil Description"
    end

    self.subject.strip!

    return self
  end

  private
  def set_default_data
    self.data ||= {}
  end
end
