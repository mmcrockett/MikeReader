class PodcastApi
  include HTTParty_with_cookies

  base_uri "http://www.reader.mmcrockett.com/entries"

  DEFAULT_QUERY = {
    query: {
      viewport: 1,
      filter: :pods
    }
  }

  def csrf
    if (true == @csrf.nil?)
      response = self.get('/', DEFAULT_QUERY)

      check_response(response)

      html_data = Nokogiri::HTML.parse(response.body)

      @csrf = html_data.css('[name=csrf-token]').first.attributes['content'].value()
    end

    return @csrf
  end

  def mark_read(id)
    params   = {
      query: {
        entry: {
          read: true
        }
      },
      headers: {
        'X-CSRF-Token' => self.csrf
      }
    }
    response = self.put("/#{id}.json", params)

    check_response(response)

    return true
  end

  def pods
    response = self.get('.json', DEFAULT_QUERY)

    check_response(response)

    return response.parsed_response
  end

  private
  def check_response(r)
    if (200 != r.code)
      raise("Failed '#{response}'.")
    end
  end
end

namespace :reader do
  desc "Check for new articles."
  task(:retrieve => :environment) do
    Feed.where(:display => true).each do |feed|
      feed.retrieve.process
      feed.save!
    end
  end

  namespace :podplayer do
    PODPLAYER_LOCATION = File.join('', 'Volumes', 'PODCAST')
    DOWNLOAD_LOCATION  = File.join('', 'tmp')
    TRIM_SETTINGS      = {
      6 => {start: 57, end: 25, title:'BS'}, #BS
      8 => {start: 0, end: 0, title:'538'},   #538 politics
      9 => {start: 57, end: 45, title:'WTP'}, #Whats the point
      11 => {start: 57, end: 25, title:'LW'} #Larry Wilmore
    }

    def ask_about_player_pods(location)
      rm_files = []

      if (false == Dir.exist?(location))
        raise "Podplayer '#{location}'  not connected."
      end

      current_pods = Dir.glob(File.join(location, '*.mp3'))

      current_pods.each do |file|
        keep = ask("Keep #{file}? ")

        if (('n' == keep.strip.downcase) || ('no' == keep.strip.downcase))
          rm_files << file
        end
      end

      return rm_files
    end

    def download_mp3(entry, download_dir)
      download_file = File.join(download_dir, "#{entry.id}.mp3")
      i = 0

      if (false == File.exist?(download_file))
        print("Downloading '#{entry.subject[0..30]}'.")
        File.open(download_file, 'wb') do |file|
          response = HTTParty.get(entry.link, stream_body: true) do |fragment|
            if (0 == (i % 1000))
              print "."
            end

            i += 1
            file.write(fragment)
          end
        end

        puts("")
      else
        puts("Skipping download - already exists '#{download_file}'.")
      end

      return download_file
    end

    def subject_to_filename(entry)
      skipped_words = [
        'the',
        'hbo',
        'by',
        'is',
        'and',
        'a',
        'for',
        'to',
        'with'
      ]
      subject = ActionView::Base.full_sanitizer.sanitize(entry.subject)
      subject = subject.gsub(/[^a-zA-Z0-9 ]+/,'')
      words   = subject.split(' ')
      allowed_size = 60
      filename = ""

      words.each do |word|
        if (0 > (allowed_size - word.size))
          break
        elsif ((false == word.empty?) && (false == skipped_words.include?(word.downcase)))
          filename += word.capitalize
          allowed_size -= word.size
        end
      end

      return "#{filename}_#{entry.post_date}"
    end

    def get_trim_setting(feed_id)
      if (false == TRIM_SETTINGS.include?(feed_id))
        raise "Unknown trim setting."
      end

      return OpenStruct.new(TRIM_SETTINGS[feed_id])
    end

    desc "Download and process the next podcasts"
    task(:process => :environment) do
      podapi       = PodcastApi.new
      poddir       = ENV['poddir'] || PODPLAYER_LOCATION
      download_dir = ENV['downloaddir'] || DOWNLOAD_LOCATION
      rm_files     = nil
      mv_files     = []
      entries      = []

      begin
        require 'highline/import'
        require 'httparty_with_cookies'
      rescue
        puts "Sorry, highline or httparty_with_cookies not installed. Likely you're on a production box."
        exit 1
      end

      rm_files     = ask_about_player_pods(poddir)

      podapi.pods.each do |pod|
        entries << Entry.new(pod)
      end

      entries.each do |entry|
        puts "#{entry.id} (#{entry.data['length']}) #{entry.subject[0..80]}"
      end

      choices = ask("Which ids?").split(' ')

      entries = entries.select { |entry| choices.include?("#{entry.id}") }

      entries.each do |entry|
        trim            = get_trim_setting(entry.feed_id)
        downloaded_file = download_mp3(entry, download_dir)
        podapi.mark_read(entry.id)
        shortened_file  = File.join(download_dir, "#{File.basename(downloaded_file, '.mp3')}.short.mp3")
        final_file      = File.join("#{trim.title}#{subject_to_filename(entry)}.short.voice.mp3")

        puts "\tShortening '#{trim}'..."
        if (false == system('sox', '-q', '-V1', "#{downloaded_file}", "#{shortened_file}", 'trim', "#{trim.start}", "-#{trim.end}"))
          raise "Failed to shorten file."
        end
        rm_files << downloaded_file

        puts "\tReducing quality..."
        if (false == system('lame', '--quiet', '-V 7', "#{shortened_file}", "#{final_file}"))
          raise "Failed to reduce quality"
        end
        rm_files << shortened_file
        mv_files << final_file
      end

      rm_files.each do |f|
        puts("Removing '#{f}'.")
        FileUtils.rm(f)
      end

      mv_files.each do |f|
        puts("Moving '#{f}' to '#{poddir}'.")
        FileUtils.mv(f, poddir)
      end

      if (false == system('diskutil', 'eject', poddir))
        raise "Failed to eject!"
      end
    end
  end
end
