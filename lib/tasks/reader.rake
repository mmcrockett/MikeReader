namespace :reader do
  desc "Check for new articles."
  task(:retrieve => :environment) do
    Feed.where(:display => true).each do |feed|
      feed.retrieve.process
      feed.save!
    end
  end
end
