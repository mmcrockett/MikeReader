require 'test_helper'

class EntriesControllerTest < ActionDispatch::IntegrationTest
  let(:entry) { entries(:one) }

  setup do
    @entries = []
    @pods = []

    Entry.all.each do |entry|
      new_entry = {
        id: entry.id,
        subject: entry.subject,
        link: entry.link,
        data: entry.data,
        read: entry.read,
        post_date: entry.post_date,
        pod: entry.pod,
        feed_id: entry.feed_id
      }

      if (true == entry.pod)
        @pods << new_entry
      else
        @entries << new_entry
      end
    end
  end

  describe 'index' do
    it 'should return a list of unread entries' do
      get entries_path

      assert_response :success

      assert_equal(Entry.articles.unread.count, response_data.size)
    end
  end

  describe '#pods' do
    it 'should return pods' do
      get pods_entries_path

      assert_response :success

      assert_equal(Entry.pods.unread.count, response_data.size)
    end
  end

  describe '#destroy' do
    it 'should mark as read' do
      delete entry_path(entry.id), params: {}

      assert_response :success
    end
  end
end
