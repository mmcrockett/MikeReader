require 'test_helper'

class FeedTest < ActiveSupport::TestCase
  describe 'feeds' do
    let(:url) { 'https://www.test.com/feeds/' }
    let(:feed) { Feed.new(url: url).retrieve }

    setup do
      FakeWeb.register_uri(:get, url, fakeweb_response(body: file, status: 200, plain: true))

      feed.process
    end

    describe 'atom' do
      let(:file) { atom_file }

      it 'can get title' do
        assert_equal("The Ringer -  All Posts", feed.title)
      end

      it 'can detect type' do
        assert_equal(true, feed.atom?)
        assert_equal(false, feed.rss?)
      end

      it 'can save entries' do
        feed.save!

        assert_equal(2, feed.reload.entries.size)
      end

      it 'ignores duplicates' do
        FakeWeb.register_uri(:get, url, fakeweb_response(body: read_test_file('atom_feed_with_updates.xml'), status: 200, plain: true))

        feed.save!
        feed.reload.retrieve.process

        assert_equal(9, feed.reload.entries.size)
      end
    end

    describe 'rss' do
      let(:file) { rss_file }

      it 'can get title' do
        assert_equal("FiveThirtyEight", feed.title)
      end

      it 'can detect type' do
        assert_equal(false, feed.atom?)
        assert_equal(true, feed.rss?)
      end

      it 'can save entries' do
        feed.save!

        assert_equal(7, feed.reload.entries.size)
      end

      it 'ignores duplicates' do
        feed.save!
        feed.reload.retrieve.process

        assert_equal(7, feed.reload.entries.size)
      end
    end

    describe 'rss podcast' do
      let(:file) { rss_podcast_file }

      it 'can get title' do
        assert_equal("The Bill Simmons Podcast", feed.title)
      end

      it 'can detect type' do
        assert_equal(false, feed.atom?)
        assert_equal(true, feed.rss?)
      end

      it 'can save entries' do
        feed.save!

        assert_equal(4, feed.reload.entries.size)
      end

      it 'ignores duplicates' do
        feed.save!
        feed.reload.retrieve.process

        assert_equal(4, feed.reload.entries.size)
      end
    end
  end
end
