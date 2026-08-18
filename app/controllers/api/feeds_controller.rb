# frozen_string_literal: true

module Api
  class FeedsController < ActionController::API
    before_action :set_feed, only: [:update]

    def index
      @feeds = Feed.all

      render json: @feeds
    end

    def create
      @feed = Feed.new(feed_params)

      if @feed.save
        render json: @feed, status: :created
      else
        render json: @feed.errors, status: :unprocessable_content
      end
    end

    def update
      if @feed.update(feed_params)
        render json: @feed
      else
        render json: @feed.errors, status: :unprocessable_content
      end
    end

    private

    def set_feed
      @feed = Feed.find(params.expect(:id))
    end

    def feed_params
      params.expect(feed: %i[name url display])
    end
  end
end
