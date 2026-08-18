# frozen_string_literal: true

require 'rss'

class Feed < ApplicationRecord
  has_many :entries

  after_save :update_history

  def retrieve(file: nil)
    raise if file.present? && false == File.exist?(file)

    response = if file.present?
                 Struct.new(:code, :content_type, :body, :parsed_response).new(200, 'json',
                                                                               @f = File.read(file), @f)
               else
                 HTTParty.get(url)
               end

    raise "!ERROR: Unable to get '#{url}' '#{response}'." unless 200 == response.code

    @feed = nil
    if response.content_type.to_s.include?('json')
      @feed = Struct.new(:feed_type, :json_data).new('json',
                                                     response.parsed_response)
    end

    @feed ||= RSS::Parser.parse(response.body, false)

    self
  end

  def origin
    @origin ||= URI.parse(url).origin
  end

  def atom?
    'atom' == @feed.feed_type
  end

  def rss?
    'rss' == @feed.feed_type
  end

  def json?
    'json' == @feed.feed_type
  end

  def title
    if true == rss?
      @feed.channel.title
    elsif true == json?
      'JSON'
    else
      @feed.title.content
    end
  end

  def process
    @published_dates = []

    self.name = title if (nil == name) || (true == name.empty?)

    items.each do |entry|
      new_entry = create_entry(entry)

      if false == new_entry.exists?
        @published_dates << (entry.try(:pubDate) || entry.try(:published).try(:content))
        entries << new_entry
      else
        Rails.logger.info("Already exists '#{new_entry.link}'.")
      end
    end

    self
  end

  private

  def items
    if true == rss?
      @feed.items
    elsif true == json?
      @feed.json_data.dig('data', 'contentNodes', 'nodes')
    else
      @feed.entries
    end
  end

  def create_entry(item)
    if true == rss?
      Entry.from_rss(item)
    elsif true == json?
      Entry.from_json(item)
    else
      Entry.from_atom(item)
    end
  end

  def update_history
    History.create!(checked_at: Time.zone.now)
  end
end
