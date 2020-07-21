require 'test_helper'

class EntriesControllerTest < ActionDispatch::IntegrationTest
  describe 'index' do
    it 'should return a list of unread entries' do
      get api_entries_path

      assert_response :success

      assert_equal(Entry.articles.unread.count, response_data.size)
    end
  end

  describe '#pods' do
    it 'should return pods' do
      get pods_api_entries_path

      assert_response :success

      assert_equal(Entry.pods.unread.count, response_data.size)
    end
  end

  describe '#destroy' do
    let(:entry) { entries(:one) }

    it 'should mark as read' do
      delete api_entry_path(entry.id), params: {}

      assert_response :success
    end
  end
end
