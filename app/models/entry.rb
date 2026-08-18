# frozen_string_literal: true

class Entry < ApplicationRecord
  belongs_to :feed

  before_save :set_default_data

  serialize :data, coder: JSON

  scope :unread, -> { where(read: false) }
  scope :by_date, -> { order(post_date: :desc) }
  scope :pods, -> { where(pod: true) }
  scope :articles, -> { where(pod: false) }

  MAX_COMPOUND_SUBJECT_SIZE = 120
  MIN_COMPOUND_SUBJECT_WORD_COUNT = 5
  MIN_COMPOUND_SUBJECT_SIZE = 30
  LONG_WORD_SIZE            = 12

  before_save -> { self.link = "#{feed.origin}/#{link}" unless link.start_with?('http') }

  def exists?
    return Entry.exists?(reference_identifier: reference_identifier) if reference_identifier.present?

    uri = URI.parse(link)
    search_path = uri.path.to_s

    search_path.chop! while true == search_path.end_with?('/')

    search_path = search_path[1..] while (true == search_path.start_with?('/')) && search_path.size.positive?

    Entry.exists?(['link LIKE ?', "%#{search_path}%"])
  end

  def self.from_rss(rss)
    entry = Entry.new
    entry.post_date = rss.pubDate
    entry.set_subject(rss.title, rss.description)
    entry.link = rss.link || rss.enclosure.url

    if nil != rss.enclosure
      entry.data ||= {}
      entry.data[:length] = rss.itunes_duration.to_s[/\d+[:\d+]*/]
      entry.pod = true
    end

    entry
  end

  def self.from_atom(atom)
    entry = Entry.new
    content_type = (atom.content&.content&.size || 0) > 5000 ? '' : '(pod)'
    entry.post_date = atom.published.content
    entry.subject   = [content_type, atom.title.content].compact_blank.join(' ')
    entry.link      = atom.link.href

    entry
  end

  def self.from_json(data)
    data = data.with_indifferent_access
    entry = Entry.new
    data[:__typename]
    entry.post_date = data[:dateGmt]
    entry.subject   = data[:title]
    entry.link      = data[:uri]
    entry.reference_identifier = data[:databaseId]

    entry
  end

  def set_subject(title, description)
    description ||= ''
    self.subject = title.to_s

    if (MIN_COMPOUND_SUBJECT_SIZE > subject.size) && (MIN_COMPOUND_SUBJECT_WORD_COUNT > subject.split.size)
      words = description.split
      first = true

      while (false == words.empty?) && (MAX_COMPOUND_SUBJECT_SIZE > subject.size)
        word = words.shift

        if true == first
          subject << ':' if false == subject.empty?

          first = false
        end

        if (MAX_COMPOUND_SUBJECT_SIZE < (word.size + subject.size)) && (LONG_WORD_SIZE < word.size)
          word = word[0..(MAX_COMPOUND_SUBJECT_SIZE - subject.size)]
        end

        subject << " #{word}"
      end
    end

    self.subject = 'nil Title and nil Description' if true == subject.empty?

    subject.strip!

    self
  end

  private

  def set_default_data
    self.data ||= {}
  end
end
