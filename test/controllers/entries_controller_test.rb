require 'test_helper'

class EntriesControllerTest < ActionController::TestCase
  setup do
    @entry = entries(:one)
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

  test "should get index" do
    get :index
    assert_response :success
    assert_nil assigns(:entries)
  end

  test "should get index as json" do
    request_json
    get :index
    assert_response :success
    assert_not_nil assigns(:entries)
    assert_equal(7, JSON.parse(@response.body).size)
    assert_equal(JSON.parse(@entries.to_json), JSON.parse(@response.body))
  end

  test "should get index as json with limited size" do
    request_json
    get :index, {viewport: 750}
    assert_response :success
    assert_not_nil assigns(:entries)
    assert_equal(5, JSON.parse(@response.body).size)
  end

  test "should get index as json with invalid viewport" do
    request_json
    get :index, {viewport: 'hello'}
    assert_response :success
    assert_not_nil assigns(:entries)
    assert_equal(7, JSON.parse(@response.body).size)
  end

  test "should get pods" do
    get :pods
    assert_response :success
    assert_nil assigns(:entries)
  end

  test "should get pods as json" do
    request_json
    get :pods
    assert_response :success
    assert_not_nil assigns(:entries)
    assert_equal(1, JSON.parse(@response.body).size)
    assert_equal(JSON.parse(@pods.to_json), JSON.parse(@response.body))
  end

  test "should update entry" do
    request_json
    patch :update, id: @entry, entry: { data: "bob", feed_id: 93, link: "blah", post_date: "27", read: !@entry.read, subject: "lll" }

    assert_response :success
    entry = Entry.new(JSON.parse(@response.body))

    @entries.first.each_pair do |k,v|
      if (:read != k)
        assert_equal(@entry.send(k), entry.send(k))
      else
        assert_equal(!@entry.send(k), entry.send(k))
      end
    end
  end
end
