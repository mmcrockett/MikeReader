# frozen_string_literal: true

class RetrieveFeedsJob < ApplicationJob
  queue_as :default

  def perform
    Feed.where(display: true).find_each do |feed|
      feed.retrieve.process
      feed.save!
    end
  end
end
