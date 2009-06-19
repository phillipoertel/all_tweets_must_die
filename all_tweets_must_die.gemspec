# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{all_tweets_must_die}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Phillip Oertel"]
  s.date = %q{2009-06-19}
  s.description = %q{Deletes all your tweets older than a certain age}
  s.email = %q{me AT phillipoertel DOHT com}
  s.extra_rdoc_files = [
    "README"
  ]
  s.files = [
    ".gitignore",
     "README",
     "Rakefile",
     "VERSION.yml",
     "examples/crontab",
     "lib/argument_validator.rb",
     "lib/hitman.rb",
     "lib/tweet.rb",
     "test/argument_validator_test.rb",
     "test/fixtures/user_timeline_noradio.json",
     "test/hitman_test.rb",
     "test/test_helper.rb",
     "test/tweet_test.rb"
  ]
  s.has_rdoc = true
  s.homepage = %q{https://github.com/phillipoertel/all_tweets_must_die}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.2}
  s.summary = %q{Deletes all your tweets older than a certain age}
  s.test_files = [
    "test/argument_validator_test.rb",
     "test/hitman_test.rb",
     "test/test_helper.rb",
     "test/tweet_test.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
