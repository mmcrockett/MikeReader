ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/spec'

class ActiveSupport::TestCase
  fixtures :all

  extend MiniTest::Spec::DSL

  FakeWeb.allow_net_connect = false

  def response_data
    JSON.parse(@response.body)
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

  def read_test_file(file, parse: false)
    file_contents   = File.open(file).read if File.exist?(file)
    file_contents ||= file_fixture(file).read

    if (true == parse)
      if (true == file.to_s.end_with?('.json'))
        return JSON.parse(file_contents)
      end
    end

    return file_contents
  end

  def atom_file
    read_test_file('atom_feed.xml')
  end

  def rss_file
    read_test_file('rss_feed.xml')
  end

  def rss_podcast_file
    read_test_file('rss_feed.podcast.xml')
  end
end
