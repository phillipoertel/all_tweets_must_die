require 'rake/testtask'

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