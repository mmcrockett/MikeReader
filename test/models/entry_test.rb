require 'test_helper'

class EntryTest < ActiveSupport::TestCase
  describe 'entry' do
    let(:parsed_response) { RSS::Parser.parse(file, false) }
    let(:expected_date) { Date.strptime("2017-08-08", "%Y-%m-%d") }
    let(:data) { parsed_response.items.first }
    let(:entry) { Entry.from_rss(data) }

    describe 'atom' do
      let(:entry) { Entry.from_atom(data) }
      let(:data) { parsed_response.entries.first }
      let(:file) { atom_file }

      it 'retrieves publish date' do
        assert_equal(expected_date, entry.post_date)
      end

      it 'has a title' do
        assert_equal("Can Real Life Compete With an Instagram Playground?", entry.subject)
      end

      it 'has a link' do
        assert_match(/instagram-playground-social-media/, entry.link)
      end

      it 'has no pod data' do
        assert_nil(entry.data)
        assert_equal(false, entry.pod?)
      end
    end

    describe 'rss' do
      let(:file) { rss_file }

      it 'retrieves publish date' do
        assert_equal(expected_date, entry.post_date)
      end

      it 'has a title' do
        assert_equal("Trump Picks A Favorite In Alabama’s GOP Senate Primary", entry.subject)
      end

      it 'has a link' do
        assert_match(/trump-picks-a-favorite-in-alabamas-gop-senate-primary/, entry.link)
      end

      it 'has no pod data' do
        assert_nil(entry.data)
        assert_equal(false, entry.pod?)
      end
    end

    describe 'rss pod' do
      let(:file) { rss_podcast_file }

      it 'retrieves publish date' do
        assert_equal(expected_date, entry.post_date)
      end

      it 'has a title' do
        assert_equal("The 25 Greatest Patriots Wins of the Brady-Belichick Era (Ep. 245)", entry.subject)
      end

      it 'has a link' do
        assert_match(/71e589d6-92e5-4536-83ca-af3cbbd1bfc9/, entry.link)
      end

      it 'can retrieve the length' do
        assert_match(/01:52:37/, entry.data[:length])
        assert_equal(true, entry.pod?)
      end
    end
  end

  describe '#subject' do
    let(:entry) { Entry.new.set_subject(title, description) }

    describe 'short title' do
      let(:title) { 'Hi' }

      describe 'with description' do
        let(:description) { 'descripty description' }

        it 'adds description' do
          assert_equal([title, description].join(': '), entry.subject)
        end
      end

      describe 'with long description' do
        let(:description) { SecureRandom.hex(Entry::MAX_COMPOUND_SUBJECT_SIZE + (Entry::MAX_COMPOUND_SUBJECT_SIZE * 2)) }

        it 'adds description' do
          assert_equal([title, description].join(': ')[0..Entry::MAX_COMPOUND_SUBJECT_SIZE + 1], entry.subject)
        end
      end

      describe 'no description' do
        let(:description) { nil }

        it 'adds description' do
          assert_equal(title, entry.subject)
        end
      end
    end

    describe 'no title' do
      let(:title) { nil }

      describe 'with description' do
        let(:description) { 'descripty description' }

        it 'adds description' do
          assert_equal(description, entry.subject)
        end
      end

      describe 'no description' do
        let(:description) { nil }

        it 'adds description' do
          assert_equal('nil Title and nil Description', entry.subject)
        end
      end
    end
  end

  describe '#exists?' do
    let(:entry) { entries(:one) }

    before do
      entry.update!(link: "https://blah.com/abc123/my-article/")
    end

    describe 'already exists' do
      it 'matches exactly' do
        assert_equal(true, Entry.new({link: "https://blah.com/abc123/my-article/"}).exists?)
      end

      it 'only differs in http(s)' do
        assert_equal(true, Entry.new({link: "http://blah.com/abc123/my-article/"}).exists?)
      end

      it 'only differs in www' do
        assert_equal(true, Entry.new({link: "https://www.blah.com/abc123/my-article/"}).exists?)
      end

      it 'has different hostname' do
        assert_equal(true, Entry.new({link: "https://blerg.com/abc123/my-article/"}).exists?)
      end

      it 'has extra slashes' do
        assert_equal(true, Entry.new({link: "https://blerg.com//abc123/my-article/"}).exists?)
      end

      it 'has no slash on the end' do
        assert_equal(true, Entry.new({link: "https://blerg.com/abc123/my-article"}).exists?)
      end

      it 'has no hostname' do
        assert_equal(true, Entry.new({link: "abc123/my-article"}).exists?)
      end
    end

    it 'is different' do
      assert_equal(false, Entry.new({link: "https://blah.com/abc123/my-article-hi/"}).exists?)
    end
  end
end
