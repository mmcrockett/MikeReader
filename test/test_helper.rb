ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  FakeWeb.allow_net_connect = false

  def request_json
    @request.headers["Content-Type"] = 'application/json'
    @request.headers["Accept"]     = 'application/json'
  end

  def fakeweb_response(params = {})
    response = {}

    if (nil != params[:body])
      if (true == params[:plain])
        response[:body] = params[:body]
      else
        response[:body] = params[:body].to_json
        response[:content_type] = 'application/json'
      end
    end

    if (nil != params[:status])
      status = params[:status]

      if (false == Rack::Utils::HTTP_STATUS_CODES.include?(status))
        raise "No code for #{status}."
      end

      response[:status] = [status, Rack::Utils::HTTP_STATUS_CODES[status]]
    end

    return response
  end

  def read_file(filename)
    if (false == File.exist?(filename))
      filename2 = File.join('test', 'fixtures', filename)

      if (false == File.exist?(filename2))
        raise "Couldn't find file '#{filename}' or '#{filename2}'."
      else
        filename = filename2
      end
    end

    if (true == filename.end_with?(".json"))
      return JSON.parse(File.read(filename))
    else
      return File.read(filename)
    end
  end

  def atom_file
    return read_file('atom_feed.xml')
  end

  def rss_file
    return read_file('rss_feed.xml')
  end

  def rss_podcast_file
    return read_file('rss_feed.podcast.xml')
  end
end
