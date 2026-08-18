ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/spec'
require 'webmock/minitest'

module ActiveSupport
  class TestCase
    fixtures :all

    extend Minitest::Spec::DSL

    WebMock.disable_net_connect!(allow_localhost: true)

    def response_data
      ::JSON.parse(@response.body)
    end

    def read_test_file(file, parse: false)
      file_contents   = File.read(file) if File.exist?(file)
      file_contents ||= file_fixture(file).read

      return JSON.parse(file_contents) if (true == parse) && (true == file.to_s.end_with?('.json'))

      file_contents
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
end
