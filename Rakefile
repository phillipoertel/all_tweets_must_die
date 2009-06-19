require 'rake/testtask'

task :default => [:test]

Rake::TestTask.new(:test) do |t|
    t.test_files = FileList['test/**/*_test.rb']
    t.verbose = true
end

task :rcov do
  sh "rcov test/*test.rb --sort=coverage"
end