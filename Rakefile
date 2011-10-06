require 'rake/testtask'

task :default => [:'test:all']

namespace :test do

  desc "run all tests"
  Rake::TestTask.new(:all) do |t|
      t.test_files = FileList['test/**/*_test.rb']
      t.verbose = true
  end

  desc "run all tests test with coverage report generation"
  task :rcov do
    sh "rcov test/*test.rb --sort=coverage && open coverage/index.html"
  end

end


namespace :run do

  task :init do
    require 'rubygems'
    require 'login'
    Dir.glob('lib/*.rb').each { |file| require file }
    include AllTweetsMustDie
  end

  desc "runs only the killer"
  task :killer => [:init] do
    runner = Runner.new(:username => @login[:user], :password => @login[:password])
    runner.run!
  end

  desc "runs only the DSL-handlers"
  task :dsl => [:init] do
    @runner = Runner.new(:username => @login[:user], :password => @login[:password], :handlers => [])
    # add the handlers from DSL
    require 'dsl/handlers'
    @runner.run!
  end

  desc "runs both the killer and the DSL-handlers"
  task :all => [:init] do
    @runner = Runner.new(:username => @login[:user], :password => @login[:password])
    # add the handlers from DSL
    require 'dsl/handlers'
    @runner.run!
  end
  
end

desc "deploy the application via rsync. specify to where with an instance variable @rsync_upload_uri."
task :deploy do
  require 'login'
  sh "rsync -r --exclude-from=.gitignore . #{@rsync_upload_uri}"
end
