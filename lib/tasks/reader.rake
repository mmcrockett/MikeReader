namespace :reader do
  desc "Check for new articles."
  task(:retrieve => :environment) do
    Feed.where(:display => true).each do |feed|
      feed.retrieve.process
      feed.save!
    end
  end

  desc "Load articles from file."
  task(:readfile => :environment) do
    Feed.where(:display => true).each do |feed|
      fn = feed.name.gsub(' ', '_').underscore

      if File.exist?(Rails.root.join(fn))
        feed.from_file(fn)
        feed.save!
      else
        puts "Not found #{fn}"
      end
    end
  end
end
