task :default => [:test]

task :test do
  test_files = Dir.glob('test/**/*_test.rb')
  test_files_string = test_files.map { |file_name| %("#{file_name}")}.join(' ')
  p test_files_string
  sh %(ruby #{test_files_string})
end