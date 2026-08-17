class RetrieveFeedsJob < ApplicationJob
  queue_as :default

  def perform
    Feed.where(display: true).each do |feed|
      feed.retrieve.process
      feed.save!
    end
  end
end
