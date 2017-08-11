require 'test_helper'

class FeedsControllerTest < ActionController::TestCase
  setup do
    @feed = feeds(:one)
    @feeds = []

    Feed.all.each do |feed|
      @feeds << {
        id: feed.id,
        name: feed.name,
        url: feed.url,
        display: feed.display,
        pod: feed.pod
      }
    end
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:feeds)
  end

  test "should get index as json" do
    request_json
    get :index
    assert_response :success
    assert_not_nil assigns(:feeds)
    assert_equal(JSON.parse(@feeds.to_json), JSON.parse(@response.body))
  end

  test "should create feed" do
    request_json

    assert_difference('Feed.count') do
      post :create, feed: { name: @feed.name, url: @feed.url, id: 99 }
    end

    assert_response :success
    feed = Feed.new(JSON.parse(@response.body))

    assert_equal(@feed.name, feed.name)
    assert_equal(@feed.url, feed.url)
    assert_not_equal(@feed.id, feed.id)
  end

  test "should update feed" do
    request_json
    patch :update, id: @feed.id, feed: { display: !@feed.display, name: @feed.name.upcase, url: @feed.url.upcase }

    assert_response :success
    feed = Feed.new(JSON.parse(@response.body))

    assert_equal(@feed.name.upcase, feed.name)
    assert_equal(@feed.url.upcase, feed.url)
    assert_equal(@feed.id, feed.id)
    assert_equal(!@feed.display, feed.display)
  end
end
