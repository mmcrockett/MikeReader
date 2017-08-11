require 'test_helper'

class EntriesControllerTest < ActionController::TestCase
  setup do
    @entry = entries(:one)
    @entries = []

    Entry.all.each do |entry|
      @entries << {
        id: entry.id,
        subject: entry.subject,
        link: entry.link,
        data: entry.data,
        read: entry.read,
        post_date: entry.post_date,
        feed_id: entry.feed_id
      }
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
    assert_equal(JSON.parse(@entries.to_json), JSON.parse(@response.body))
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
