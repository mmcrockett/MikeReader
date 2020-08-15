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

  describe '#history' do
    describe 'no history' do
      it 'returns empty' do
        get history_api_entries_path

        assert_response :success

        assert_nil(response_data['checked_at'])
      end
    end

    describe 'with history' do
      let(:last_checked_time) { 3.days.ago }

      before do
        History.create!(checked_at: 5.days.ago)
        History.create!(checked_at: last_checked_time)
      end

      it 'returns last' do
        get history_api_entries_path

        assert_response :success

        assert_equal(last_checked_time.as_json, response_data['checked_at'])
      end
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
