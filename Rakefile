require 'rake/testtask'

# for gem packaging etc. see http://github.com/technicalpickles/jeweler
require 'jeweler'
Jeweler::Tasks.new do |gemspec|
  gemspec.name = "all_tweets_must_die"
  gemspec.summary = "Deletes all your tweets older than a certain age"
  gemspec.email = "me AT phillipoertel DOHT com"
  gemspec.homepage = "https://github.com/phillipoertel/all_tweets_must_die"
  gemspec.description = "Deletes all your tweets older than a certain age"
  gemspec.authors = ["Phillip Oertel"]
end

task :default => [:test]

Rake::TestTask.new(:test) do |t|
    t.test_files = FileList['test/**/*_test.rb']
    t.verbose = true
end

task :rcov do
  sh "rcov test/*test.rb --sort=coverage"
end

task :run do
  require 'rubygems'
  require 'login'
  Dir.glob('lib/*.rb').each { |file| require file }
  hitman = AllTweetsMustDie::Hitman.new(:username => @login[:user], :password => @login[:password])
  hitman.run!
end

task :deploy do
  require 'login'
  sh "rsync -r --exclude-from=.gitignore . #{@rsync_upload_uri}"
end