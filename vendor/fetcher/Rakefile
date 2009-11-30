require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'gemspec'

desc 'Default: run unit tests.'
task :default => :test

desc "Generate gemspec"
task :gemspec do
  File.open("#{Dir.pwd}/#{GEM_NAME}.gemspec", 'w') do |f|
    f.write(GEM_SPEC.to_ruby)
  end
end

desc 'Test the fetcher plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the fetcher plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Fetcher'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
