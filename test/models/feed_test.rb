require 'test_helper'

class FeedTest < ActiveSupport::TestCase
  ATOM_URL = "https://www.test.com/atom/"
  RSS_URL  = "https://www.test.com/rss/"
  POD_URL  = "https://www.test.com/pod/"

  def setup
    FakeWeb.register_uri(:get, ATOM_URL, [
      fakeweb_response(body: atom_file, status: 200, plain: true),
      fakeweb_response(body: read_file('atom_feed_with_updates.xml'), status:200, plain: true)
    ])
    FakeWeb.register_uri(:get, RSS_URL, fakeweb_response(body: rss_file, status: 200, plain: true))
    FakeWeb.register_uri(:get, POD_URL, fakeweb_response(body: rss_podcast_file, status: 200, plain: true))

    @atom_feed = Feed.new(name: 'atom', url: ATOM_URL).retrieve
    @rss_feed  = Feed.new(name: 'rss', url: RSS_URL).retrieve
    @pod_feed  = Feed.new(name: 'pod', url: POD_URL).retrieve

    @feeds = []
    @feeds << @atom_feed
    @feeds << @rss_feed
    @feeds << @pod_feed

    super
  end

  test "can get title" do
    @feeds.each do |feed|
      feed.process
    end

    assert_equal("The Ringer -  All Posts", @atom_feed.title)
    assert_equal("FiveThirtyEight", @rss_feed.title)
    assert_equal("The Bill Simmons Podcast", @pod_feed.title)
  end

  test "can detect feed type" do
    assert(@atom_feed.atom?)
    assert_equal(false, @atom_feed.rss?)
    assert(@rss_feed.rss?)
    assert_equal(false, @rss_feed.atom?)
    assert(@pod_feed.rss?)
    assert_equal(false, @pod_feed.atom?)
  end

  test "can process the entries" do
    @feeds.each do |feed|
      feed.process
    end

    @feeds.each do |feed|
      feed.save!
      feed.reload
    end

    assert_equal(2, @atom_feed.entries.size)
    assert_equal(7, @rss_feed.entries.size)
    assert_equal(4, @pod_feed.entries.size)
    assert_equal("The Ringer -  All Posts", @atom_feed.title)
    assert_equal("FiveThirtyEight", @rss_feed.title)
    assert_equal("The Bill Simmons Podcast", @pod_feed.title)
  end

  test "can process the entries and ignore duplicates" do
    @feeds.each do |feed|
      feed.process
      feed.save!
      feed.reload
      feed.retrieve.process
      feed.save!
      feed.reload
    end

    assert_equal(9, @atom_feed.entries.size)
    assert_equal(7, @rss_feed.entries.size)
    assert_equal(4, @pod_feed.entries.size)
  end
end
