require 'test_helper'

class EntryTest < ActiveSupport::TestCase
  ATOM_DATA = RSS::Parser.parse(File.read(File.join('test', 'fixtures', 'atom_feed.xml')), false)
  RSS_DATA  = RSS::Parser.parse(File.read(File.join('test', 'fixtures', 'rss_feed.xml')), false)
  POD_DATA  = RSS::Parser.parse(File.read(File.join('test', 'fixtures', 'rss_feed.podcast.xml')), false)

  def setup
    @atom_data  = ATOM_DATA.entries.first
    @rss_data   = RSS_DATA.items.first
    @pod_data   = POD_DATA.items.first
    @atom_entry = Entry.from_atom(@atom_data)
    @rss_entry  = Entry.from_rss(@rss_data)
    @pod_entry  = Entry.from_rss(@pod_data)

    @entries = {
      atom: @atom_entry,
      rss: @rss_entry,
      pod: @pod_entry
    }

    super
  end

  test "can retrieve the publish date" do
    expected_date = Date.strptime("2017-08-08", "%Y-%m-%d")

    @entries.values.each do |entry|
      assert_equal(expected_date, entry.post_date)
    end
  end

  test "can retrieve the title" do
    assert_match(/Can Real Life Compete With an Instagram/, @entries[:atom].subject)
    assert_match(/The 25 Greatest Patriots Wins of the Brady-Belichick Era/, @entries[:pod].subject)
    assert_match(/Trump Picks A Favorite In Alabama/, @entries[:rss].subject)
  end

  test "can retrieve the link" do
    assert_match(/instagram-playground-social-media/, @entries[:atom].link)
    assert_match(/71e589d6-92e5-4536-83ca-af3cbbd1bfc9/, @entries[:pod].link)
    assert_match(/trump-picks-a-favorite-in-alabamas-gop-senate-primary/, @entries[:rss].link)
  end

  test "can retrieve the length of podcasts" do
    assert_nil(@entries[:atom].data)
    assert_equal(false, @entries[:atom].pod)
    assert_match(/01:52:37/, @entries[:pod].data[:length])
    assert(@entries[:pod].pod)
    assert_nil(@entries[:rss].data)
    assert_equal(false, @entries[:rss].pod)
  end

  test "can tell if already exists" do
    data = {subject: "hello", link: "https://blah.com/abc123/my-article/", post_date: entries(:one).post_date}

    Entry.new(data).save!

    assert_equal(true, Entry.new({link: "https://blah.com/abc123/my-article/"}).exists?)
    assert_equal(true, Entry.new({link: "http://blah.com/abc123/my-article/"}).exists?)
    assert_equal(true, Entry.new({link: "https://www.blah.com/abc123/my-article/"}).exists?)
    assert_equal(true, Entry.new({link: "https://blerg.com/abc123/my-article/"}).exists?)
    assert_equal(true, Entry.new({link: "https://blerg.com//abc123/my-article/"}).exists?)
    assert_equal(true, Entry.new({link: "https://blerg.com/abc123/my-article"}).exists?)
    assert_equal(true, Entry.new({link: "abc123/my-article"}).exists?)
    assert_equal(false, Entry.new({link: "https://blah.com/abc123/my-article-hi/"}).exists?)
  end
end
