require 'test_helper'

class FeedsControllerTest < ActionDispatch::IntegrationTest
  let(:feed) { feeds(:one) }

  describe 'index' do
    it 'returns a list of feeds' do
      get feeds_path

      assert_response :success
      assert_equal(Feed.count, response_data.size)
    end
  end

  describe 'create' do
    let(:new_feed) { Feed.new(response_data) }
    let(:params) {
      {
        name: 'great feed',
        url: 'https://blahblah.com',
        id: 8123
      }
    }

    it 'should create a feed' do
      assert_difference('Feed.count') do
        post feeds_path, params: { feed: params }
      end

      assert_response :success

      assert_equal(new_feed.name, params[:name])
      assert_equal(new_feed.url, params[:url])
      assert_not_equal(new_feed.id, params[:id])
    end
  end

  describe 'update' do
    let(:updated_feed) { Feed.new(response_data) }
    let(:params) {
      {
        display: !feed.display,
        name: feed.name.upcase,
        url: feed.url.upcase
      }
    }

    it "should update feed" do
      put feed_path(feed.id), params: { feed: params }

      assert_response :success

      assert_equal(feed.name.upcase, updated_feed.name)
      assert_equal(feed.url.upcase, updated_feed.url)
      assert_equal(feed.id, updated_feed.id)
      assert_equal(!feed.display, updated_feed.display)
    end
  end
end
